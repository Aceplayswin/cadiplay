"""USDT display scale.

Wallets are stored in units that are 100 times the USDT amount the player sees.
6000 stored is 60 USDT. Game launch, callbacks, and client reads and writes
convert at this boundary so the stored ledger does not have to be rewritten.

The ledger currency is always USD. Clients and UIs render that same unit as
USDT (1:1). Incoming client codes (including USDT) are stored as USD.
"""

from decimal import Decimal, ROUND_HALF_UP

# Stored on wallets, transactions, sessions, and program settings.
BACKEND_CURRENCY = 'USD'
# Returned to web / admin / affiliate / agent screens.
DISPLAY_CURRENCY = 'USDT'

USDT_SCALE = Decimal('100')
_DP = Decimal('0.01')
MIN_DEPOSIT_USDT = Decimal('30')
MIN_WITHDRAWAL_USDT = Decimal('50')


def store_currency(_value=None) -> str:
    """House currency written to the database. Always USD."""
    return BACKEND_CURRENCY


def present_currency(_value=None) -> str:
    """Currency label clients show. Always USDT."""
    return DISPLAY_CURRENCY


def usdt_amount(value) -> float:
    """Stored units to the USDT figure clients and the game provider use."""
    dec = Decimal(str(0 if value is None else value))
    return float((dec / USDT_SCALE).quantize(_DP, rounding=ROUND_HALF_UP))


def stored_amount(value) -> Decimal:
    """A USDT figure from a client or the game provider, back into stored units."""
    dec = Decimal(str(0 if value is None else value))
    return (dec * USDT_SCALE).quantize(_DP, rounding=ROUND_HALF_UP)


_WALLET_KEYS = (
    'real', 'main', 'bonus', 'total', 'exposure', 'locked',
    'pendingWithdrawal', 'available',
)


def present_wallet(data: dict) -> dict:
    """Copy a wallet (or breakdown) dict with money fields in USDT."""
    out = dict(data)
    for key in _WALLET_KEYS:
        if out.get(key) is not None:
            out[key] = usdt_amount(out[key])
    if 'bonuses' in out:
        out['bonuses'] = [
            {**row, 'amount': usdt_amount(row.get('amount'))}
            for row in out['bonuses']
        ]
    for key in ('bonusTotal', 'deposits', 'withdrawals'):
        if key in out:
            out[key] = usdt_amount(out[key])
    if 'gamePlay' in out and isinstance(out['gamePlay'], dict):
        out['gamePlay'] = {k: usdt_amount(v) for k, v in out['gamePlay'].items()}
    return out
