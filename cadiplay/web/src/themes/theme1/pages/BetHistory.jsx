'use client';

// Theme1 Bet History — play/session records + aggregate P&L off the shared
// games API. Each row expands into round-by-round detail; tapping a round
// opens a modal. Dark glass look.

import { Fragment, useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ChevronDown, Clock, Loader2, X } from 'lucide-react';
import { api } from '@/services/api';
import { useAuthStore } from '@/store/auth';
import { formatDateTime } from '@/lib/datetime';
import { formatAmount as usdt } from '@/lib/money';


export default function Theme1BetHistory() {
  const router = useRouter();
  const token = useAuthStore((s) => s.token);
  const [records, setRecords] = useState([]);
  const [pnl, setPnl] = useState(null);
  const [loading, setLoading] = useState(true);
  const [expanded, setExpanded] = useState(null);
  const [rounds, setRounds] = useState({});
  const [selectedRound, setSelectedRound] = useState(null);

  useEffect(() => {
    if (!token) {
      router.push('/login');
      return;
    }
    let active = true;
    Promise.all([
      api('/api/v1/games/history?limit=50').catch(() => ({ records: [] })),
      api('/api/v1/games/pnl').catch(() => null),
    ])
      .then(([hist, p]) => {
        if (!active) return;
        setRecords(Array.isArray(hist?.records) ? hist.records : []);
        setPnl(p);
      })
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [token, router]);

  const toggle = async (sessionUid) => {
    if (expanded === sessionUid) {
      setExpanded(null);
      return;
    }
    setExpanded(sessionUid);
    if (rounds[sessionUid] && !rounds[sessionUid].error) return;

    setRounds((r) => ({ ...r, [sessionUid]: { loading: true, rounds: [] } }));
    try {
      const data = await api(`/api/v1/games/history/${sessionUid}/rounds`);
      setRounds((r) => ({
        ...r,
        [sessionUid]: { loading: false, rounds: data.rounds ?? [] },
      }));
    } catch (e) {
      setRounds((r) => ({
        ...r,
        [sessionUid]: { loading: false, rounds: [], error: e.message },
      }));
    }
  };

  if (!token) return null;

  return (
    <main className="mx-auto max-w-6xl flex-1 px-4 py-8">
      <h1 className="text-2xl font-bold">Bet History</h1>
      <p className="mt-1 text-sm text-slate-400">
        Your play sessions and results. Tap a row for round details.
      </p>

      <section className="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <Summary label="Total staked" value={pnl?.total_bet} />
        <Summary label="Total won" value={pnl?.total_win} />
        <Summary
          label="Net P&L"
          value={pnl?.profit_loss}
          tone={Number(pnl?.profit_loss ?? 0) >= 0 ? 'up' : 'down'}
        />
        <Summary
          label="Awaiting result"
          value={pnl?.pending_amount}
          tone="pending"
          hint={
            pnl?.pending_rounds
              ? `${pnl.pending_rounds} bet${pnl.pending_rounds === 1 ? '' : 's'} open`
              : null
          }
        />
      </section>

      <section className="mt-8">
        <div className="mb-4 flex items-center justify-between">
          <h2 className="text-lg font-semibold">Sessions</h2>
          {!loading && records.length > 0 && (
            <span className="text-xs text-slate-500">
              {records.length} session{records.length === 1 ? '' : 's'}
            </span>
          )}
        </div>

        {loading ? (
          <div className="card-glass space-y-2 p-4">
            {[0, 1, 2, 3, 4].map((i) => (
              <div key={i} className="h-10 animate-pulse rounded-lg bg-white/[0.03]" />
            ))}
          </div>
        ) : records.length === 0 ? (
          <div className="card-glass px-4 py-12 text-center text-sm text-slate-500">
            No bets yet.{' '}
            <Link href="/" className="text-brand-400 hover:underline">
              Explore games
            </Link>
          </div>
        ) : (
          <div className="card-glass overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full min-w-[880px] text-sm">
                <thead>
                  <tr className="border-b border-white/10 text-left text-[0.7rem] uppercase tracking-wide text-slate-500">
                    <th className="px-5 py-3 font-medium">Game</th>
                    <th className="px-5 py-3 font-medium">Category</th>
                    <th className="px-5 py-3 font-medium">Date</th>
                    <th className="px-5 py-3 text-center font-medium">Rounds</th>
                    <th className="px-5 py-3 text-right font-medium">Staked</th>
                    <th className="px-5 py-3 text-right font-medium">Won</th>
                    <th className="px-5 py-3 text-right font-medium">Result</th>
                    <th className="w-10 px-2 py-3" />
                  </tr>
                </thead>
                <tbody>
                  {records.map((r) => {
                    const open = expanded === r.session_uid;
                    const detail = rounds[r.session_uid];
                    return (
                      <Fragment key={r.session_uid}>
                        <tr
                          onClick={() => toggle(r.session_uid)}
                          className="cursor-pointer border-b border-white/5 transition last:border-0 hover:bg-white/[0.03]"
                        >
                          <td className="px-5 py-3 font-medium text-white">{r.game_name}</td>
                          <td className="px-5 py-3 capitalize text-slate-400">
                            {(r.category || '—').replace(/_/g, ' ')}
                          </td>
                          <td className="px-5 py-3 text-slate-400">
                            {formatDateTime(r.last_played_at || r.created_at)}
                          </td>
                          <td className="px-5 py-3 text-center text-slate-400">
                            {r.rounds}
                            {r.pending_rounds > 0 && (
                              <span className="ml-1 text-[0.65rem] text-amber-400">
                                ({r.pending_rounds} open)
                              </span>
                            )}
                          </td>
                          <td className="px-5 py-3 text-right tabular-nums text-slate-300">
                            {usdt(r.total_bet)}
                          </td>
                          <td className="px-5 py-3 text-right tabular-nums text-slate-300">
                            {usdt(r.total_win)}
                          </td>
                          <td className="px-5 py-3 text-right">
                            <ResultCell record={r} />
                          </td>
                          <td className="px-2 py-3 text-slate-500">
                            <ChevronDown
                              className={`h-4 w-4 transition-transform ${open ? 'rotate-180' : ''}`}
                            />
                          </td>
                        </tr>
                        {open && (
                          <tr className="border-b border-white/5">
                            <td colSpan={8} className="bg-black/20 px-5 py-4">
                              <RoundDetails detail={detail} onSelectRound={setSelectedRound} />
                            </td>
                          </tr>
                        )}
                      </Fragment>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </section>

      {selectedRound && (
        <RoundDetailModal round={selectedRound} onClose={() => setSelectedRound(null)} />
      )}
    </main>
  );
}

function ResultCell({ record }) {
  if (record.result === 'pending') {
    return (
      <span className="inline-flex items-center gap-1 rounded-full bg-amber-500/15 px-2.5 py-0.5 text-xs font-semibold text-amber-400">
        <Clock className="h-3 w-3" /> Pending
      </span>
    );
  }
  const up = Number(record.profit_loss) >= 0;
  return (
    <span className={`font-semibold tabular-nums ${up ? 'text-green-400' : 'text-red-400'}`}>
      {up ? '+' : '−'}
      {usdt(Math.abs(Number(record.profit_loss)))}
    </span>
  );
}

function RoundDetails({ detail, onSelectRound }) {
  if (!detail || detail.loading) {
    return (
      <p className="flex items-center gap-2 text-sm text-slate-500">
        <Loader2 className="h-4 w-4 animate-spin" /> Loading rounds…
      </p>
    );
  }
  if (detail.error) {
    return <p className="text-sm text-red-400">{detail.error}</p>;
  }
  if (!detail.rounds.length) {
    return <p className="text-sm text-slate-500">No round details recorded yet.</p>;
  }

  return (
    <div className="overflow-x-auto">
      <table className="w-full min-w-[880px] text-xs">
        <thead>
          <tr className="text-left uppercase tracking-wide text-slate-500">
            <th className="py-2 pr-4 font-medium">Round</th>
            <th className="py-2 pr-4 font-medium">Game</th>
            <th className="py-2 pr-4 font-medium">Category</th>
            <th className="py-2 pr-4 font-medium">Placed</th>
            <th className="py-2 pr-4 font-medium">Settled</th>
            <th className="py-2 pr-4 text-right font-medium">Stake</th>
            <th className="py-2 pr-4 text-right font-medium">Win</th>
            <th className="py-2 pr-4 text-right font-medium">Wallet balance</th>
            <th className="py-2 text-right font-medium">Result</th>
          </tr>
        </thead>
        <tbody className="text-slate-300">
          {detail.rounds.map((rd) => (
            <tr
              key={rd.id}
              onClick={() => onSelectRound?.(rd)}
              className="cursor-pointer border-t border-white/5 transition hover:bg-white/[0.04]"
            >
              <td className="py-2 pr-4 font-mono text-[0.7rem] text-slate-400">
                {rd.game_round || rd.serial_number}
              </td>
              <td className="py-2 pr-4">{rd.game_name || '—'}</td>
              <td className="py-2 pr-4 capitalize text-slate-400">
                {(rd.category || '—').replace(/_/g, ' ')}
              </td>
              <td className="py-2 pr-4 text-slate-400">{formatDateTime(rd.created_at)}</td>
              <td className="py-2 pr-4 text-slate-400">
                {rd.settled_at ? formatDateTime(rd.settled_at) : '—'}
              </td>
              <td className="py-2 pr-4 text-right tabular-nums">{usdt(rd.bet_amount)}</td>
              <td className="py-2 pr-4 text-right tabular-nums">{usdt(rd.win_amount)}</td>
              <td className="py-2 pr-4 text-right tabular-nums text-slate-400">
                {rd.balance_after == null ? '—' : usdt(rd.balance_after)}
              </td>
              <td className="py-2 text-right">
                {rd.result === 'pending' ? (
                  <span className="font-semibold text-amber-400">Pending</span>
                ) : (
                  <span
                    className={`font-semibold tabular-nums ${
                      rd.profit_loss >= 0 ? 'text-green-400' : 'text-red-400'
                    }`}
                  >
                    {rd.profit_loss >= 0 ? '+' : '−'}
                    {usdt(Math.abs(rd.profit_loss))}
                  </span>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

function RoundDetailModal({ round, onClose }) {
  useEffect(() => {
    const onKey = (e) => {
      if (e.key === 'Escape') onClose?.();
    };
    document.addEventListener('keydown', onKey);
    const prevOverflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => {
      document.removeEventListener('keydown', onKey);
      document.body.style.overflow = prevOverflow;
    };
  }, [onClose]);

  const isPending = round.result === 'pending';
  const up = Number(round.profit_loss) >= 0;

  const rows = [
    ['Round', round.game_round || round.serial_number || '—'],
    ['Game', round.game_name || '—'],
    ['Category', (round.category || '—').replace(/_/g, ' ')],
    ['Placed', formatDateTime(round.created_at)],
    ['Settled', round.settled_at ? formatDateTime(round.settled_at) : '—'],
    ['Stake', usdt(round.bet_amount)],
    ['Win', usdt(round.win_amount)],
    ['Balance before', round.balance_before == null ? '—' : usdt(round.balance_before)],
    ['Balance after', round.balance_after == null ? '—' : usdt(round.balance_after)],
    ['Status', isPending ? 'Pending' : (round.settle_status || round.result || '—')],
  ];

  return (
    <div
      className="fixed inset-0 z-[100] flex items-center justify-center p-4"
      role="dialog"
      aria-modal="true"
    >
      <button
        aria-label="Close"
        onClick={onClose}
        className="absolute inset-0 cursor-default bg-black/60 backdrop-blur-sm"
      />
      <div className="card-glass relative z-10 w-full max-w-md overflow-hidden">
        <div className="relative border-b border-brand-500/30 bg-gradient-to-r from-brand-500/20 to-transparent px-6 py-5">
          <button
            onClick={onClose}
            aria-label="Close"
            className="absolute right-3 top-3 grid h-7 w-7 place-items-center rounded-full bg-white/10 text-white transition hover:bg-white/20"
          >
            <X className="h-4 w-4" />
          </button>
          <p className="text-lg font-bold uppercase tracking-tight text-brand-300">Round details</p>
          <p className="mt-1.5 font-mono text-[0.7rem] font-semibold text-slate-400">
            {round.game_round || round.serial_number}
          </p>
        </div>

        <div className="max-h-[70vh] overflow-y-auto p-6">
          <dl className="space-y-3">
            {rows.map(([label, value]) => (
              <div key={label} className="flex items-center justify-between gap-4 text-sm">
                <dt className="text-[0.65rem] font-semibold uppercase tracking-wide text-slate-500">
                  {label}
                </dt>
                <dd className="text-right font-medium tabular-nums text-white">{value}</dd>
              </div>
            ))}
            <div className="flex items-center justify-between gap-4 border-t border-white/10 pt-3 text-sm">
              <dt className="text-[0.65rem] font-semibold uppercase tracking-wide text-slate-500">
                Result
              </dt>
              <dd>
                {isPending ? (
                  <span className="inline-flex items-center gap-1 rounded-full bg-amber-500/15 px-2.5 py-0.5 text-xs font-semibold text-amber-400">
                    <Clock className="h-3 w-3" /> Pending
                  </span>
                ) : (
                  <span
                    className={`font-bold tabular-nums ${up ? 'text-green-400' : 'text-red-400'}`}
                  >
                    {up ? '+' : '−'}
                    {usdt(Math.abs(Number(round.profit_loss)))}
                  </span>
                )}
              </dd>
            </div>
          </dl>
        </div>
      </div>
    </div>
  );
}

function Summary({ label, value, tone, hint }) {
  const color =
    tone === 'up'
      ? 'text-green-400'
      : tone === 'down'
        ? 'text-red-400'
        : tone === 'pending'
          ? 'text-amber-400'
          : 'text-white';
  return (
    <div className="card-glass p-4">
      <p className="text-[0.65rem] uppercase tracking-wide text-slate-500">{label}</p>
      <p className={`mt-1 text-lg font-bold tabular-nums ${color}`}>{usdt(value)}</p>
      {hint && <p className="mt-0.5 text-[0.65rem] text-slate-500">{hint}</p>}
    </div>
  );
}
