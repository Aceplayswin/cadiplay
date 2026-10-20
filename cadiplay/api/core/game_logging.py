"""Structured, file-based logging for the game-play lifecycle.

Every meaningful event in a play — the launch attempt, the launch result (or the
exact reason it failed/was interrupted), and each aggregator callback with its
bet / win / loss / net and resulting balance — is written to ``logs/games.log``.
Anything that went wrong (launch failures, decrypt errors, rejected or
unsettleable callbacks, unexpected errors) is *additionally* written to
``logs/games_error.log`` so the failures are easy to find and diagnose.

Separately, everything the aggregator sends us is written verbatim to
``logs/raw_games.log``: every callback body exactly as it arrived (logged before
anything parses or decrypts it, so even one that is later rejected is on disk),
its decrypted payload, the plain balance ack, and the response to every launch
request. The same pieces are joined into one JSON object per request and
written, once, to ``logs/raw_games.json`` when that request finishes.

This complements the database ``CallbackLog`` audit trail with a plain-text,
greppable record on disk that survives independently of the tenant DB. The
handlers/rotation are configured by ``LOGGING`` in ``config/settings.py``.

Lines are emitted as ``event tenant=… key=value …`` so they can be filtered with
ordinary tools, e.g.::

    grep launch_failed logs/games_error.log
    grep 'serial=12345' logs/games.log
    grep 12345 logs/raw_games.log
    grep '"serial_number":"12345"' logs/raw_games.json
"""

from __future__ import annotations

import contextvars
import json
import logging
from datetime import datetime
from decimal import Decimal

from tenants.state import get_current_tenant_id

log = logging.getLogger('games')
raw_log = logging.getLogger('games.raw')
# Own logger, not a propagating child: a JSON line must not also land in
# raw_games.log. propagate=False is set on the logger in settings.
raw_json_log = logging.getLogger('games.raw.json')

# One open JSON object per in-flight request. A ContextVar keeps two callbacks
# on the same worker from writing into each other's record.
_open_record: contextvars.ContextVar[dict | None] = contextvars.ContextVar(
    'games_raw_json_record', default=None,
)

_SEARCH_FIELDS = (
    'serial_number', 'member_account', 'game_uid', 'game_round',
    'bet_amount', 'win_amount', 'currency_code', 'timestamp',
)


def _fmt(**fields) -> str:
    parts = []
    for key, value in fields.items():
        if value is None or value == '':
            continue
        if isinstance(value, Decimal):
            value = f'{value:.2f}'
        text = str(value)
        # Keep each field on one whitespace-delimited token so the line stays
        # greppable; collapse internal whitespace in free-text issues/messages.
        if any(ch.isspace() for ch in text):
            text = '"' + ' '.join(text.split()) + '"'
        parts.append(f'{key}={text}')
    return ' '.join(parts)


def _message(event: str, **fields) -> str:
    tenant = get_current_tenant_id() or '-'
    body = _fmt(**fields)
    message = f'{event} tenant={tenant}'
    if body:
        message = f'{message} {body}'
    return message


def _emit(level: int, event: str, **fields) -> None:
    log.log(level, _message(event, **fields))


# --------------------------------------------------------------------------- #
# Launch
# --------------------------------------------------------------------------- #

def launch_attempt(user_id, game_uid, game_name=None) -> None:
    _emit(logging.INFO, 'launch_attempt', user=user_id, game_uid=game_uid, game=game_name)


def launch_success(user_id, game_uid, session_uid, game_name=None, url=None) -> None:
    _emit(
        logging.INFO, 'launch_success',
        user=user_id, game_uid=game_uid, session=session_uid, game=game_name, url=url,
    )


def launch_failed(user_id, game_uid, code, issue, game_name=None) -> None:
    """A launch could not start / was interrupted — `code` + `issue` say why."""
    _emit(
        logging.WARNING, 'launch_failed',
        user=user_id, game_uid=game_uid, code=code, game=game_name, issue=issue,
    )


# --------------------------------------------------------------------------- #
# Callback settlement
# --------------------------------------------------------------------------- #

def callback_received(serial_number, member_account, game_uid) -> None:
    _emit(
        logging.INFO, 'callback_received',
        serial=serial_number, member=member_account, game_uid=game_uid,
    )


def settled(user_id, game_uid, serial_number, bet, win, balance, session_uid=None) -> None:
    net = (win or Decimal('0')) - (bet or Decimal('0'))
    outcome = 'win' if net > 0 else 'loss' if net < 0 else 'even'
    _emit(
        logging.INFO, 'settled',
        user=user_id, game_uid=game_uid, serial=serial_number, outcome=outcome,
        bet=bet, win=win, net=net, balance=balance, session=session_uid,
    )


def heartbeat(user_id, game_uid, serial_number, balance) -> None:
    _emit(
        logging.INFO, 'heartbeat',
        user=user_id, game_uid=game_uid, serial=serial_number, balance=balance,
    )


def duplicate(user_id, game_uid, serial_number, reason) -> None:
    _emit(
        logging.INFO, 'duplicate',
        user=user_id, game_uid=game_uid, serial=serial_number, reason=reason,
    )


def sports_settlement_received(
    user_id, member_account, game_uid, serial_number, bet_slip_id, operation,
    selection_count, trade_profit, payout,
) -> None:
    """A sportsbook reported the final result of a bet slip."""
    _emit(
        logging.INFO, 'sports_settlement_received',
        user=user_id, member=member_account, game_uid=game_uid, serial=serial_number,
        bet_slip=bet_slip_id, operation=operation, selections=selection_count,
        trade_profit=trade_profit, payout=payout,
    )


def sports_bet_settled(
    user_id, serial_number, bet_id, round_id, status, profit, stake, win, issue=None,
) -> None:
    """One stake resolved by a bet-slip settlement.

    Logged as a warning — so it is also in games_error.log — when ``issue``
    says the money paid disagrees with the provider's result for the bet.
    """
    net = (win or Decimal('0')) - (stake or Decimal('0'))
    outcome = 'win' if net > 0 else 'loss' if net < 0 else 'even'
    _emit(
        logging.WARNING if issue else logging.INFO, 'sports_bet_settled',
        user=user_id, serial=serial_number, bet_id=bet_id, round=round_id,
        status=status, profit=profit, stake=stake, win=win, outcome=outcome,
        issue=issue,
    )


def sports_bet_unpaid(user_id, serial_number, bet_id, round_id, status, profit, stake) -> None:
    """A bet the provider reports won/voided, but this callback paid nothing
    for it — left pending until the payout arrives (or the stale sweep)."""
    _emit(
        logging.WARNING, 'sports_bet_unpaid',
        user=user_id, serial=serial_number, bet_id=bet_id, round=round_id,
        status=status, profit=profit, stake=stake,
    )


def sports_slip_settled(user_id, serial_number, bet_slip_id, settled, awaiting, payout, balance) -> None:
    _emit(
        logging.INFO, 'sports_slip_settled',
        user=user_id, serial=serial_number, bet_slip=bet_slip_id, settled=settled,
        awaiting_payout=awaiting, payout=payout, balance=balance,
    )


def sports_settlement_rejected(
    user_id, member_account, game_uid, serial_number, bet_slip_id, game_round, bet_ids, issue,
) -> None:
    """A bet-slip settlement that could not be applied; nothing was settled and
    the provider is told to retry."""
    _emit(
        logging.WARNING, 'sports_settlement_rejected',
        user=user_id, member=member_account, game_uid=game_uid, serial=serial_number,
        bet_slip=bet_slip_id, game_round=game_round, bet_ids=','.join(bet_ids),
        issue=issue,
    )


def wagering_failed(user_id, serial_number, issue) -> None:
    """Turnover could not be applied to the player's pending bonuses.

    The round itself settled — only the bonus progress is affected, so the
    player may need the wagering re-applied for this round manually.
    """
    _emit(
        logging.ERROR, 'wagering_failed',
        user=user_id, serial=serial_number, issue=issue,
    )


def rejected(serial_number, member_account, game_uid, issue) -> None:
    """A callback could not be settled (bad payload, unknown account, no wallet)."""
    _emit(
        logging.WARNING, 'rejected',
        serial=serial_number, member=member_account, game_uid=game_uid, issue=issue,
    )


def decrypt_error(issue) -> None:
    _emit(logging.ERROR, 'decrypt_error', issue=issue)


def callback_error(issue) -> None:
    """Unexpected/uncaught failure while handling a callback."""
    _emit(logging.ERROR, 'callback_error', issue=issue)


# --------------------------------------------------------------------------- #
# Raw aggregator traffic (logs/raw_games.log)
# --------------------------------------------------------------------------- #

def _emit_raw(event: str, name: str, raw: str, **fields) -> None:
    # The raw text goes last and untouched, so everything after "<name>=" is
    # exactly what the aggregator sent. Only line breaks are escaped: each
    # record stays on one line and a crafted body cannot forge extra records.
    text = raw.replace('\r', '\\r').replace('\n', '\\n')
    raw_log.info('%s %s=%s', _message(event, **fields), name, text)


def _tenant() -> str:
    return get_current_tenant_id() or '-'


def _now_ts() -> str:
    """Local time with milliseconds: ``YYYY-MM-DD HH:MM:SS,mmm``."""
    now = datetime.now()
    return now.strftime('%Y-%m-%d %H:%M:%S,') + f'{now.microsecond // 1000:03d}'


def _dumps(value) -> str:
    return json.dumps(
        value, ensure_ascii=False, separators=(',', ':'), default=str,
    )


def _parse_jsonish(text: str):
    """Parse a body that looks like JSON; otherwise keep the original string.

    One extra unwrap: if the parsed object has a ``data`` string that itself
    looks like JSON, parse that string once. Do not recurse.
    """
    if not isinstance(text, str):
        text = '' if text is None else str(text)
    stripped = text.lstrip()
    if not stripped or stripped[0] not in '{[':
        return text
    try:
        parsed = json.loads(text)
    except (ValueError, TypeError):
        return text
    if isinstance(parsed, dict):
        data = parsed.get('data')
        if isinstance(data, str) and data.lstrip()[:1] in '{[':
            try:
                parsed['data'] = json.loads(data)
            except (ValueError, TypeError):
                pass
    return parsed


def _copy_search_fields(record: dict, payload: dict) -> None:
    """Lift a few payload fields to the top of the record for log shippers."""
    for key in _SEARCH_FIELDS:
        value = payload.get(key)
        if value is None or value == '':
            continue
        record[key] = value
    data = payload.get('data')
    if not isinstance(data, dict):
        return
    transaction = data.get('transaction')
    if not isinstance(transaction, dict):
        return
    operation = transaction.get('operation')
    if operation is None or operation == '':
        return
    record['operation'] = operation


def _flush_open() -> None:
    """Write the open record as one NDJSON line, if there is one.

    The slot is cleared before the write so a failure inside the write cannot
    make the next request append onto a half-finished dict.
    """
    record = _open_record.get()
    if record is None:
        return
    _open_record.set(None)
    raw_json_log.info(_dumps(record))


def flush_raw_json() -> None:
    """Flush any JSON record still open. Safe to call when nothing is open."""
    _flush_open()


def _begin(fields: dict) -> None:
    """Start a record. An earlier record still open is flushed first."""
    if _open_record.get() is not None:
        _flush_open()
    record = {'ts': _now_ts()}
    record.update(fields)
    _open_record.set(record)


def raw_callback(body, ip=None, path=None, content_type=None) -> None:
    """A callback exactly as it was posted to us, before anything parses it."""
    text = body if isinstance(body, str) else ('' if body is None else str(body))
    _emit_raw('callback_body', 'body', text, ip=ip, path=path, content_type=content_type)
    _begin({
        'event': 'callback',
        'tenant': _tenant(),
        'ip': ip or '',
        'path': path or '',
        'content_type': content_type or '',
        'request': _parse_jsonish(text),
    })


def raw_callback_payload(text) -> None:
    """The decrypted payload of a callback, as the aggregator encrypted it."""
    raw = text if isinstance(text, str) else ('' if text is None else str(text))
    _emit_raw('callback_payload', 'payload', raw)
    parsed = _parse_jsonish(raw)
    record = _open_record.get()
    if record is None:
        fields = {'event': 'callback', 'tenant': _tenant(), 'payload': parsed}
        if isinstance(parsed, dict):
            _copy_search_fields(fields, parsed)
        _begin(fields)
        _flush_open()
        return
    record['payload'] = parsed
    if isinstance(parsed, dict):
        _copy_search_fields(record, parsed)


def raw_callback_ack(body: dict) -> None:
    """The plain balance ack, before it is encrypted into the HTTP response."""
    compact = _dumps(body)
    _emit_raw('callback_ack', 'payload', compact)
    record = _open_record.get()
    if record is None:
        _begin({'event': 'callback', 'tenant': _tenant(), 'ack': body})
        _flush_open()
        return
    record['ack'] = body


def raw_callback_response(content, code=None) -> None:
    """The HTTP body actually returned to the aggregator, then flush the record."""
    if isinstance(content, bytes):
        text = content.decode('utf-8', errors='replace')
    elif content is None:
        text = ''
    else:
        text = str(content)
    parsed = _parse_jsonish(text)
    if code is None and isinstance(parsed, dict) and 'code' in parsed:
        code = parsed.get('code')
    fields = {'response': parsed}
    if code is not None and code != '':
        fields['code'] = code
    record = _open_record.get()
    if record is None:
        _begin({'event': 'callback', 'tenant': _tenant(), **fields})
    else:
        record.update(fields)
    _emit_raw('callback_response', 'body', text, code=code)
    _flush_open()


def raw_launch_response(user_id, game_uid, url, status, body) -> None:
    """The aggregator's HTTP response to a launch request, error pages included."""
    text = body if isinstance(body, str) else ('' if body is None else str(body))
    _emit_raw(
        'launch_response', 'body', text,
        user=user_id, game_uid=game_uid, url=url, status=status,
    )
    _begin({
        'event': 'launch',
        'tenant': _tenant(),
        'user': user_id,
        'game_uid': game_uid,
        'url': url,
        'status': status,
        'response': _parse_jsonish(text),
    })


def raw_launch_payload(user_id, game_uid, text) -> None:
    """The decrypted ``payload`` of a launch response that came encrypted."""
    raw = text if isinstance(text, str) else ('' if text is None else str(text))
    _emit_raw('launch_payload', 'payload', raw, user=user_id, game_uid=game_uid)
    parsed = _parse_jsonish(raw)
    record = _open_record.get()
    if record is None:
        _begin({
            'event': 'launch',
            'tenant': _tenant(),
            'user': user_id,
            'game_uid': game_uid,
            'payload': parsed,
        })
        _flush_open()
        return
    record['payload'] = parsed
