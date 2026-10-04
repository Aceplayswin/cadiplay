// Amounts are stored at 100× the USDT figure shown — the same convention as
// admin (`money`/`usd`) and affiliate (`usd`). 5000 in the API is USDT 50.

export const AMOUNT_SCALE = 100;

export function toDisplayAmount(stored) {
  const n = Number(stored ?? 0);
  return Number.isFinite(n) ? n / AMOUNT_SCALE : 0;
}

export function toStoredAmount(display) {
  const n = Number(display ?? 0);
  return Number.isFinite(n) ? Math.round(n * AMOUNT_SCALE * 100) / 100 : 0;
}

export function formatAmountNumber(stored, options = {}) {
  const { minimumFractionDigits = 0, maximumFractionDigits = 2 } = options;
  return toDisplayAmount(stored).toLocaleString('en-US', {
    minimumFractionDigits,
    maximumFractionDigits,
  });
}

/** "USDT 50" — pass `{ minimumFractionDigits: 2 }` for wallet chips. */
export function formatAmount(stored, options = {}) {
  const { prefix = 'USDT ', ...rest } = options;
  return `${prefix}${formatAmountNumber(stored, rest)}`;
}
