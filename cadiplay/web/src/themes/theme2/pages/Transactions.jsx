'use client';

// Theme2 Transactions — cashier ledger, dark navy / amber.

import { useEffect, useMemo, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { api } from '@/services/api';
import { useAuthStore } from '@/store/auth';
import { formatDateTime as formatDate } from '@/lib/datetime';
import { T2Card } from '../components/ui';
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

export default function Theme2Transactions() {
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
    <div className="mx-auto max-w-[1100px] px-4 py-8">
      <h1 className="font-display text-2xl font-black text-white">Transactions</h1>
      <p className="mt-1 text-sm text-slate-400">
        Money in and out of your wallet — deposits, withdrawals and bonuses. For
        your stakes and winnings, see{' '}
        <Link href="/bet-history" className="font-bold text-amber-400 hover:underline">
          bet history
        </Link>
        .
      </p>

      <section className="mt-6 grid grid-cols-2 gap-3 lg:grid-cols-4">
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

      <div className="mb-3 mt-8 flex flex-wrap items-center gap-2">
        {TX_FILTERS.map((f) => (
          <button
            key={f.value}
            type="button"
            onClick={() => setFilter(f.value)}
            className={`rounded-full px-3 py-1.5 text-xs font-bold uppercase tracking-wide transition ${
              filter === f.value
                ? 'bg-gradient-to-r from-amber-400 to-amber-600 text-black'
                : 'border border-white/10 bg-[#070d16] text-slate-400 hover:border-amber-400/50 hover:text-amber-400'
            }`}
          >
            {f.label}
          </button>
        ))}
        {!loading && (
          <span className="ml-auto text-xs font-semibold text-slate-500">
            {visible.length} transaction{visible.length === 1 ? '' : 's'}
          </span>
        )}
      </div>

      {loading ? (
        <T2Card className="space-y-2 p-4">
          {[0, 1, 2, 3, 4].map((i) => (
            <div key={i} className="h-10 animate-pulse rounded-lg bg-white/[0.04]" />
          ))}
        </T2Card>
      ) : error ? (
        <T2Card className="px-4 py-12 text-center text-sm font-semibold text-red-400">{error}</T2Card>
      ) : visible.length === 0 ? (
        <T2Card className="px-4 py-12 text-center text-sm text-slate-500">
          {txs.length === 0 ? (
            <>
              No transactions yet.{' '}
              <Link href="/deposit" className="font-bold text-amber-400 hover:underline">
                Make a deposit
              </Link>
            </>
          ) : (
            'No transactions of this type.'
          )}
        </T2Card>
      ) : (
        <T2Card className="overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full min-w-[760px] text-sm">
              <thead>
                <tr className="border-b border-white/5 bg-[#070d16] text-left text-[0.65rem] uppercase tracking-wide text-slate-500">
                  <th className="px-5 py-3 font-bold">Type</th>
                  <th className="px-5 py-3 font-bold">Date</th>
                  <th className="px-5 py-3 font-bold">Method</th>
                  <th className="px-5 py-3 font-bold">Reference</th>
                  <th className="px-5 py-3 font-bold">Status</th>
                  <th className="px-5 py-3 text-right font-bold">Amount</th>
                </tr>
              </thead>
              <tbody>
                {visible.map((t) => (
                  <tr
                    key={t.id}
                    className="border-b border-white/5 transition last:border-0 hover:bg-white/[0.03]"
                  >
                    <td className="px-5 py-3 font-bold text-white">{TX_LABELS[t.type] ?? t.type}</td>
                    <td className="px-5 py-3 text-slate-400">{formatDate(t.created_at)}</td>
                    <td className="px-5 py-3 text-slate-400">{t.payment_method || '—'}</td>
                    <td className="px-5 py-3 font-mono text-[0.7rem] text-slate-500">
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
        </T2Card>
      )}
    </div>
  );
}

function AmountCell({ tx }) {
  const credit = CREDIT_TYPES.has(tx.type);
  const tone = !isSettled(tx.status)
    ? 'text-slate-500'
    : credit
      ? 'text-emerald-400'
      : 'text-red-400';
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
      ? 'bg-emerald-500/15 text-emerald-400'
      : tone === 'bad'
        ? 'bg-red-500/15 text-red-400'
        : 'bg-amber-500/15 text-amber-400';
  return (
    <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-bold capitalize ${cls}`}>
      {status}
    </span>
  );
}

function Summary({ label, value, tone, hint }) {
  const color =
    tone === 'up'
      ? 'text-emerald-400'
      : tone === 'down'
        ? 'text-red-400'
        : tone === 'pending'
          ? 'text-amber-400'
          : 'text-white';
  return (
    <T2Card className="p-4">
      <p className="text-[0.6rem] font-bold uppercase tracking-wide text-slate-500">{label}</p>
      <p className={`mt-1 font-display text-lg font-black tabular-nums ${color}`}>{usdt(value)}</p>
      {hint && <p className="mt-0.5 text-[0.65rem] text-slate-500">{hint}</p>}
    </T2Card>
  );
}
