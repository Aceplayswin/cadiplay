// Shared formatting. Amounts are stored at 100x the USD figure shown.

export function usd(value) {
  return `USD ${(Number(value || 0) / 100).toLocaleString('en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;
}

export function num(value) {
  return Number(value || 0).toLocaleString('en-IN');
}

export function pct(value, digits = 1) {
  return `${Number(value || 0).toFixed(digits)}%`;
}

// Dates are shown in full everywhere on the platform — day, month, year and a
// wall-clock time down to the second. Support and finance reconcile against
// these strings, and a timestamp rounded to the minute loses the ordering of
// events that land in the same minute. `dateStyle`/`timeStyle` cannot be mixed
// with a `second` field, so the parts are spelled out explicitly.
const DATE_PARTS = { day: '2-digit', month: 'short', year: 'numeric' };
const TIME_PARTS = { hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true };

/** "12 Mar 2024, 10:00:45 pm" */
export function fmtDate(value) {
  if (!value) return '—';
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return '—';
  return d.toLocaleString('en-IN', { ...DATE_PARTS, ...TIME_PARTS });
}

/** Alias of {@link fmtDate}, kept so callers can say what they mean. */
export const fmtDateTime = fmtDate;

/** "12 Mar 2024" — only for places that genuinely have no time, like a date-range label. */
export function fmtDateShort(value) {
  if (!value) return '—';
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return '—';
  return d.toLocaleDateString('en-IN', DATE_PARTS);
}

/** "10:00:45 pm" — the time half, when the date is already shown alongside. */
export function fmtTime(value) {
  if (!value) return '—';
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return '—';
  return d.toLocaleTimeString('en-IN', TIME_PARTS);
}

/** "4 min ago" style, for the activity feed. */
export function relativeTime(value) {
  if (!value) return '';
  const diff = Date.now() - new Date(value).getTime();
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return 'just now';
  if (mins < 60) return `${mins} min ago`;
  const hours = Math.floor(mins / 60);
  if (hours < 24) return `${hours} hr ago`;
  const days = Math.floor(hours / 24);
  if (days < 30) return `${days}d ago`;
  // Past a month "ago" stops being useful — fall back to the full stamp.
  return fmtDate(value);
}

/** Title-cases a snake_case enum value for display. */
export function label(value) {
  if (!value) return '—';
  return String(value)
    .replace(/_/g, ' ')
    .replace(/\b\w/g, (c) => c.toUpperCase());
}
