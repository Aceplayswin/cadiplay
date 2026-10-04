'use client';

// Theme4 Transactions — cashier ledger, teal exchange.

import { useEffect, useMemo, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { api } from '@/services/api';
import { useAuthStore } from '@/store/auth';
import { formatDateTime as formatDate } from '@/lib/datetime';
import { T4Card, T4FormPage } from '../components/ui';
import {
  CREDIT_TYPES,
  TX_FILTERS,
  TX_LABELS,
  cashierOnly,
  isSettled,
  statusTone,
  summarise,
} from '@/lib/transactions';

const usdt = (n) => `USDT ${Number(n ?? 0).toLocaleString('en-IN')}`;

export default function Theme4Transactions() {
  const router = useRouter();
  const token = useAuthStore((s) => s.token);
  const [txs, setTxs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [filter, setFilter] = useState('all');

  useEffect(() => {
    if (!token) {
      router.push('/login');
      return;
    }
    let active = true;
    api('/api/v1/wallet/transactions')
      .then((data) => {
        if (!active) return;
        setTxs(cashierOnly(Array.isArray(data) ? data : []));
      })
      .catch((e) => active && setError(e.message))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [token, router]);

  const totals = useMemo(() => summarise(txs), [txs]);
  const visible = useMemo(
    () => (filter === 'all' ? txs : txs.filter((t) => t.type === filter)),
    [txs, filter],
  );

  if (!token) return null;

  return (
    <T4FormPage
      title="Transactions"
      subtitle={
        <>
          Money in and out of your wallet — deposits, withdrawals and bonuses. For
          your stakes and winnings, see{' '}
          <Link href="/bet-history" className="font-bold text-[#0e7480] hover:underline">
            bet history
          </Link>
          .
        </>
      }
      maxWidth="max-w-[1100px]"
    >
      <section className="mt-4 grid grid-cols-2 gap-3 lg:grid-cols-4">
        <Summary label="Total credited" value={totals.credited} tone="up" />
        <Summary label="Total debited" value={totals.debited} tone="down" />
        <Summary
          label="Pending"
          value={totals.pending}
          tone="pending"
          hint={
            totals.pendingCount
              ? `${totals.pendingCount} awaiting approval`
              : 'Nothing awaiting approval'
          }
        />
        <Summary label="Net movement" value={totals.net} tone={totals.net >= 0 ? 'up' : 'down'} />
      </section>

      <div className="mb-3 mt-6 flex flex-wrap items-center gap-2">
        {TX_FILTERS.map((f) => (
          <button
            key={f.value}
            type="button"
            onClick={() => setFilter(f.value)}
            className={`rounded px-3 py-1.5 text-xs font-black uppercase tracking-wide transition ${
              filter === f.value
                ? 'bg-gradient-to-b from-[#17a2b0] to-[#0e7480] text-white'
                : 'border border-[#0e7480]/25 bg-white text-[#5d7378] hover:border-[#0e7480] hover:text-[#0e7480]'
            }`}
          >
            {f.label}
          </button>
        ))}
        {!loading && (
          <span className="ml-auto text-xs font-semibold text-[#8aa0a4]">
            {visible.length} transaction{visible.length === 1 ? '' : 's'}
          </span>
        )}
      </div>

      {loading ? (
        <T4Card className="space-y-2 p-4">
          {[0, 1, 2, 3, 4].map((i) => (
            <div key={i} className="h-10 animate-pulse rounded bg-black/[0.04]" />
          ))}
        </T4Card>
      ) : error ? (
        <T4Card className="px-4 py-12 text-center text-sm font-semibold text-[#e5342c]">{error}</T4Card>
      ) : visible.length === 0 ? (
        <T4Card className="px-4 py-12 text-center text-sm text-[#8aa0a4]">
          {txs.length === 0 ? (
            <>
              No transactions yet.{' '}
              <Link href="/deposit" className="font-bold text-[#0e7480] hover:underline">
                Make a deposit
              </Link>
            </>
          ) : (
            'No transactions of this type.'
          )}
        </T4Card>
      ) : (
        <T4Card className="overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full min-w-[760px] text-sm">
              <thead>
                <tr className="border-b border-black/[0.07] bg-[#eef6f7] text-left text-[0.65rem] uppercase tracking-wide text-[#8aa0a4]">
                  <th className="px-5 py-3 font-black">Type</th>
                  <th className="px-5 py-3 font-black">Date</th>
                  <th className="px-5 py-3 font-black">Method</th>
                  <th className="px-5 py-3 font-black">Reference</th>
                  <th className="px-5 py-3 font-black">Status</th>
                  <th className="px-5 py-3 text-right font-black">Amount</th>
                </tr>
              </thead>
              <tbody>
                {visible.map((t) => (
                  <tr
                    key={t.id}
                    className="border-b border-black/[0.05] transition last:border-0 hover:bg-[#eef6f7]"
                  >
                    <td className="px-5 py-3 font-bold text-[#13272b]">
                      {TX_LABELS[t.type] ?? t.type}
                    </td>
                    <td className="px-5 py-3 text-[#5d7378]">{formatDate(t.created_at)}</td>
                    <td className="px-5 py-3 text-[#5d7378]">{t.payment_method || '—'}</td>
                    <td className="px-5 py-3 font-mono text-[0.7rem] text-[#8aa0a4]">
                      {t.reference_number || '—'}
                    </td>
                    <td className="px-5 py-3">
                      <StatusPill status={t.status} />
                    </td>
                    <td className="px-5 py-3 text-right">
                      <AmountCell tx={t} />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </T4Card>
      )}
    </T4FormPage>
  );
}

function AmountCell({ tx }) {
  const credit = CREDIT_TYPES.has(tx.type);
  const tone = !isSettled(tx.status)
    ? 'text-[#8aa0a4]'
    : credit
      ? 'text-[#0e7480]'
      : 'text-[#e5342c]';
  return (
    <span className={`font-black tabular-nums ${tone}`}>
      {credit ? '+' : '−'}
      {usdt(Math.abs(Number(tx.amount ?? 0)))}
    </span>
  );
}

function StatusPill({ status }) {
  const tone = statusTone(status);
  const cls =
    tone === 'good'
      ? 'bg-[#0e7480]/12 text-[#0e7480]'
      : tone === 'bad'
        ? 'bg-[#e5342c]/12 text-[#e5342c]'
        : 'bg-[#b45309]/12 text-[#b45309]';
  return (
    <span className={`inline-flex items-center rounded px-2.5 py-0.5 text-xs font-black capitalize ${cls}`}>
      {status}
    </span>
  );
}

function Summary({ label, value, tone, hint }) {
  const color =
    tone === 'up'
      ? 'text-[#0e7480]'
      : tone === 'down'
        ? 'text-[#e5342c]'
        : tone === 'pending'
          ? 'text-[#b45309]'
          : 'text-[#13272b]';
  return (
    <T4Card className="p-4">
      <p className="text-[0.6rem] font-black uppercase tracking-wide text-[#8aa0a4]">{label}</p>
      <p className={`mt-1 font-display text-lg font-black tabular-nums ${color}`}>{usdt(value)}</p>
      {hint && <p className="mt-0.5 text-[0.65rem] text-[#8aa0a4]">{hint}</p>}
    </T4Card>
  );
}
