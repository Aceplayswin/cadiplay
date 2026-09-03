"""CoinGecko client: the live INR ⇄ USDT rate used to price crypto deposits.

Players fund and are paid in INR, but the crypto rail settles in USDT (Tether),
so both sides of the cashier need to know what one USDT is worth in rupees right
now. That number comes from CoinGecko's public Simple Price API::

    GET https://api.coingecko.com/api/v3/simple/price
        ?ids=tether&vs_currencies=inr&include_last_updated_at=true

    -> {"tether": {"inr": 94.53, "last_updated_at": 1788460840}}

A demo/Pro API key may be supplied, in which case it is sent as a header and,
for a Pro key, the Pro host is used instead; without a key the public endpoint is
used, which is rate-limited to a handful of calls per minute. That limit is why
the rate is cached in-process rather than fetched per request, with a
*last-known-good* copy kept so a CoinGecko outage or a 429 doesn't take the
cashier down — a slightly stale rate is far better than no rate at all.
"""

from __future__ import annotations

import json
import logging
import urllib.error
import urllib.parse
import urllib.request
from decimal import Decimal, InvalidOperation

from django.conf import settings
from django.core.cache import cache

logger = logging.getLogger(__name__)

# ``fresh`` expires quickly so the quoted rate tracks the market; ``lkg`` (last
# known good) lives long and is served when a fetch fails; ``cooldown`` throttles
# retries so a rate-limited or unreachable CoinGecko isn't hammered per request.
_FRESH_KEY = 'exchange_rate:usdt_inr'
_LKG_KEY = 'exchange_rate:usdt_inr_lkg'
_COOLDOWN_KEY = 'exchange_rate:usdt_inr_cooldown'

_LKG_TTL = 24 * 60 * 60  # keep the last good rate for a day
_COOLDOWN_TTL = 30       # seconds to wait before retrying after a failure

_PUBLIC_HOST = 'https://api.coingecko.com/api/v3'
_PRO_HOST = 'https://pro-api.coingecko.com/api/v3'

# CoinGecko's id for Tether, and the fiat we quote it against.
_COIN_ID = 'tether'
_VS_CURRENCY = 'inr'


def _api_key() -> str:
    return getattr(settings, 'COINGECKO_API_KEY', '') or ''


def _is_pro_key() -> bool:
    return bool(getattr(settings, 'COINGECKO_PRO', False))


def _timeout() -> int:
    return int(getattr(settings, 'COINGECKO_HTTP_TIMEOUT', 10))


def _fresh_ttl() -> int:
    return int(getattr(settings, 'COINGECKO_CACHE_TTL', 60))


def _fallback_rate() -> Decimal | None:
    """Configured rate of last resort, used only when CoinGecko has never
    answered since this process started (so there is no last-known-good copy)."""
    raw = getattr(settings, 'USDT_INR_FALLBACK_RATE', '') or ''
    if not raw:
        return None
    try:
        rate = Decimal(str(raw))
    except (InvalidOperation, ValueError):
        logger.warning('exchange_rate: USDT_INR_FALLBACK_RATE is not a number: %r', raw)
        return None
    return rate if rate > 0 else None


def _http_fetch() -> dict | None:
    """Fetch the current USDT price in INR from CoinGecko.

    Returns ``{'rate': Decimal, 'last_updated_at': int | None}``, or ``None`` on
    any error so the caller can fall back to the last-known-good rate.
    """
    host = _PRO_HOST if _is_pro_key() else _PUBLIC_HOST
    query = urllib.parse.urlencode({
        'ids': _COIN_ID,
        'vs_currencies': _VS_CURRENCY,
        'include_last_updated_at': 'true',
    })
    url = f'{host}/simple/price?{query}'
    req = urllib.request.Request(url, method='GET')
    req.add_header('User-Agent', 'cadiplay-exchange-rate/1.0')
    req.add_header('Accept', 'application/json')
    key = _api_key()
    if key:
        # Pro and demo keys use different header names; sending the wrong one is
        # treated as no key at all, which silently drops us to public limits.
        req.add_header('x-cg-pro-api-key' if _is_pro_key() else 'x-cg-demo-api-key', key)
    try:
        with urllib.request.urlopen(req, timeout=_timeout()) as resp:
            payload = resp.read()
        data = json.loads(payload) if payload else None
    except urllib.error.HTTPError as e:
        # 429 is the common one: the public endpoint's per-minute cap.
        logger.warning('exchange_rate: %s returned HTTP %s', url, e.code)
        return None
    except urllib.error.URLError as e:
        logger.warning('exchange_rate: could not reach %s: %s', url, e.reason)
        return None
    except (json.JSONDecodeError, ValueError) as e:
        logger.warning('exchange_rate: invalid JSON from %s: %s', url, e)
        return None
    except TimeoutError as e:
        # A read timeout raises a bare TimeoutError (not wrapped in URLError),
        # so it must be caught explicitly or it would 500 the calling request.
        logger.warning('exchange_rate: timed out reading %s: %s', url, e)
        return None
    except OSError as e:
        logger.warning('exchange_rate: transport error for %s: %s', url, e)
        return None

    quote = (data or {}).get(_COIN_ID) or {}
    raw_rate = quote.get(_VS_CURRENCY)
    if raw_rate is None:
        logger.warning('exchange_rate: no %s price in CoinGecko response', _VS_CURRENCY)
        return None
    try:
        # str() first: going through float would bake rounding error into a
        # number that prices real money.
        rate = Decimal(str(raw_rate))
    except (InvalidOperation, ValueError):
        logger.warning('exchange_rate: non-numeric rate from CoinGecko: %r', raw_rate)
        return None
    if rate <= 0:
        logger.warning('exchange_rate: non-positive rate from CoinGecko: %s', rate)
        return None

    last_updated = quote.get('last_updated_at')
    return {
        'rate': rate,
        'last_updated_at': int(last_updated) if last_updated else None,
    }


def get_usdt_inr_rate() -> dict | None:
    """Return the current USDT→INR quote, fetching it if the cached one is stale.

    Shape: ``{'rate': Decimal, 'last_updated_at': int | None, 'stale': bool}``,
    where ``stale`` marks a last-known-good or configured fallback rate served
    because CoinGecko could not be reached. ``None`` when no rate is available
    at all, so callers can refuse to quote rather than invent a price.
    """
    cached = cache.get(_FRESH_KEY)
    if cached is not None:
        return {**cached, 'stale': False}

    # Recently failed — don't retry yet; serve last-known-good if we have it.
    if cache.get(_COOLDOWN_KEY):
        return _stale_rate()

    quote = _http_fetch()
    if quote is not None:
        cache.set(_FRESH_KEY, quote, _fresh_ttl())
        cache.set(_LKG_KEY, quote, _LKG_TTL)
        return {**quote, 'stale': False}

    # Fetch failed: back off briefly and fall back to the last good rate.
    cache.set(_COOLDOWN_KEY, True, _COOLDOWN_TTL)
    return _stale_rate()


def _stale_rate() -> dict | None:
    """Last-known-good quote, else the configured fallback, else nothing."""
    lkg = cache.get(_LKG_KEY)
    if lkg is not None:
        return {**lkg, 'stale': True}
    fallback = _fallback_rate()
    if fallback is not None:
        return {'rate': fallback, 'last_updated_at': None, 'stale': True}
    return None


def invalidate() -> None:
    """Drop the cached rate (forces a fresh fetch next call)."""
    cache.delete(_FRESH_KEY)
    cache.delete(_COOLDOWN_KEY)
