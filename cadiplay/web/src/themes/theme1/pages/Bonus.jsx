'use client';

// Theme1 My Bonuses — awarded ledger + wagering progress (/api/v1/bonuses/mine),
// coupon redeem, and claimable offers. Dark glass look. Separate from
// /promotions, which is the public poster catalogue.

import { useCallback, useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Gift, Sparkles, Ticket, Check, AlertCircle, Lock, Clock } from 'lucide-react';
import { api } from '@/services/api';
import { useAuthStore } from '@/store/auth';
import { formatDateTime as formatDate } from '@/lib/datetime';
import { useCouponRedeem } from '@/hooks/useCouponRedeem';

const usdt = (n) => `USDT ${Number(n ?? 0).toLocaleString('en-IN')}`;

const SOURCE_LABEL = {
  joining: 'Welcome bonus',
  deposit: 'Deposit bonus',
  referral: 'Referral bonus',
  game: 'Play bonus',
  cashback: 'Cashback',
  promo: 'Promo code',
  manual: 'Special credit',
};

const STATUS_TONE = {
  active: 'bg-emerald-500/15 text-emerald-400',
  pending: 'bg-amber-500/15 text-amber-400',
  completed: 'bg-sky-500/15 text-sky-400',
  expired: 'bg-slate-500/15 text-slate-400',
  forfeited: 'bg-red-500/15 text-red-400',
};

const t1Input =
  'w-full rounded-lg border border-white/10 bg-surface-700 px-4 py-3 text-white outline-none focus:border-brand-500/60';
const t1Btn =
  'rounded-xl bg-brand-500 px-5 py-2.5 text-sm font-semibold text-surface-900 transition hover:bg-brand-400 disabled:cursor-not-allowed disabled:opacity-50';

export default function Theme1Bonus() {
  const router = useRouter();
  const { token, wallet, refreshSession } = useAuthStore();
  const [bonuses, setBonuses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [offers, setOffers] = useState([]);

  useEffect(() => {
    if (!token) {
      router.push('/login');
      return;
    }
    let active = true;
    refreshSession();
    api('/api/v1/bonuses/mine')
      .then((data) => active && setBonuses(Array.isArray(data) ? data : []))
      .catch(() => active && setBonuses([]))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [token, router, refreshSession]);

  const walletReal = wallet?.real ?? wallet?.main;
  const walletBonus = wallet?.bonus;
  useEffect(() => {
    if (!token) return undefined;
    let active = true;
    api('/api/v1/promotions')
      .then((data) => active && setOffers(Array.isArray(data) ? data : []))
      .catch(() => active && setOffers([]));
    return () => {
      active = false;
    };
  }, [token, walletReal, walletBonus]);

  const onRedeemed = useCallback(async () => {
    await api('/api/v1/bonuses/mine')
      .then((data) => setBonuses(Array.isArray(data) ? data : []))
      .catch(() => {});
    api('/api/v1/promotions')
      .then((data) => setOffers(Array.isArray(data) ? data : []))
      .catch(() => {});
    refreshSession();
  }, [refreshSession]);

  if (!token) return null;

  const activeCount = bonuses.filter((b) => b.status === 'active').length;

  return (
    <main className="mx-auto max-w-4xl flex-1 px-4 py-8">
      <h1 className="text-2xl font-bold">My Bonuses</h1>
      <p className="mt-1 text-sm text-slate-400">
        Bonus credits you hold and their wagering progress.
      </p>

      <RedeemCoupon onRedeemed={onRedeemed} />

      <AvailableOffers offers={offers} onClaimed={onRedeemed} />

      <section className="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2">
        <div className="card-glass border border-brand-500/20 p-5">
          <p className="text-[0.65rem] uppercase tracking-wide text-brand-300">Bonus balance</p>
          <p className="mt-1 text-3xl font-bold text-white">{usdt(wallet?.bonus)}</p>
          <p className="mt-1 text-xs text-slate-500">
            Playable now · becomes withdrawable once wagering is cleared
          </p>
        </div>
        <div className="card-glass border border-emerald-500/20 p-5">
          <p className="text-[0.65rem] uppercase tracking-wide text-emerald-300">Real balance</p>
          <p className="mt-1 text-3xl font-bold text-white">{usdt(wallet?.real ?? wallet?.main)}</p>
          <p className="mt-1 text-xs text-slate-500">Yours to withdraw any time</p>
        </div>
      </section>

      <div className="mt-6 flex flex-wrap items-center gap-3">
        <Link href="/promotions" className={`inline-flex items-center gap-1.5 ${t1Btn}`}>
          <Sparkles className="h-4 w-4" /> Browse promotions
        </Link>
        {!loading && (
          <span className="text-xs text-slate-500">
            {activeCount} active bonus{activeCount === 1 ? '' : 'es'}
          </span>
        )}
      </div>

      <section className="mt-6 space-y-3">
        {loading ? (
          [0, 1, 2].map((i) => <div key={i} className="card-glass h-28 animate-pulse" />)
        ) : bonuses.length === 0 ? (
          <div className="card-glass flex flex-col items-center gap-2 p-12 text-center">
            <Gift className="h-8 w-8 text-brand-400" />
            <p className="text-lg font-semibold">No bonuses yet</p>
            <p className="text-sm text-slate-400">
              Claim an offer from the promotions page to get started.
            </p>
          </div>
        ) : (
          bonuses.map((b) => <BonusCard key={b.id} bonus={b} />)
        )}
      </section>
    </main>
  );
}

function RedeemCoupon({ onRedeemed }) {
  const {
    code,
    onCodeChange,
    check,
    redeem,
    checking,
    redeeming,
    preview,
    error,
    success,
    busy,
  } = useCouponRedeem({ onRedeemed });

  const submit = (e) => {
    e.preventDefault();
    if (preview?.valid) redeem();
    else check();
  };

  return (
    <div className="card-glass mt-6 p-5">
      <div className="flex items-center gap-2">
        <Ticket className="h-4 w-4 text-brand-400" />
        <h2 className="text-base font-semibold text-white">Redeem a coupon code</h2>
      </div>
      <p className="mt-1 text-xs text-slate-500">
        Got a code? Enter it below to add the bonus to your account. Each code can
        be redeemed once per player.
      </p>

      <form onSubmit={submit} className="mt-4 flex flex-col gap-2 sm:flex-row">
        <input
          value={code}
          onChange={(e) => onCodeChange(e.target.value)}
          placeholder="e.g. GET100"
          maxLength={40}
          autoComplete="off"
          spellCheck={false}
          aria-label="Coupon code"
          className={`${t1Input} flex-1 font-mono uppercase tracking-[0.2em] placeholder:font-sans placeholder:tracking-normal`}
        />
        <button type="submit" disabled={busy || !code.trim()} className={`${t1Btn} shrink-0`}>
          {checking ? 'Checking…' : redeeming ? 'Redeeming…' : preview?.valid ? 'Redeem' : 'Apply'}
        </button>
      </form>

      {preview?.valid && !success && (
        <div className="mt-3 rounded-xl border border-emerald-500/20 bg-emerald-500/10 p-3">
          <p className="text-sm font-semibold text-white">
            {preview.title} · {usdt(preview.amount)}
          </p>
          {preview.wagering_required > 0 && (
            <p className="mt-0.5 text-xs text-slate-400">
              Credited instantly and playable. Wager {usdt(preview.wagering_required)} (
              {preview.wagering_multiplier}×) to unlock it for withdrawal.
            </p>
          )}
          <p className="mt-1 text-xs font-semibold text-emerald-400">Press Redeem to claim it.</p>
        </div>
      )}

      {success && (
        <div className="mt-3 flex items-start gap-2 rounded-xl border border-emerald-500/20 bg-emerald-500/10 p-3">
          <Check className="mt-0.5 h-4 w-4 shrink-0 text-emerald-400" />
          <div>
            <p className="text-sm font-semibold text-white">
              {usdt(success.amount)} added — {success.title}
            </p>
            <p className="mt-0.5 text-xs text-slate-400">
              {success.withdrawable
                ? 'Credited to your withdrawable balance.'
                : `Added to your bonus balance — play with it now. Complete ${usdt(
                    success.wagering_required,
                  )} of wagering to make it withdrawable.`}
            </p>
          </div>
        </div>
      )}

      {error && (
        <div className="mt-3 flex items-start gap-2 rounded-xl border border-red-500/20 bg-red-500/10 p-3">
          <AlertCircle className="mt-0.5 h-4 w-4 shrink-0 text-red-400" />
          <div className="min-w-0 flex-1">
            <p className="text-sm font-semibold text-red-400">{error}</p>
            {preview && !preview.valid && preview.requirements?.some((r) => !r.met) && (
              <OfferRequirements offer={preview} />
            )}
          </div>
        </div>
      )}
    </div>
  );
}

function BonusCard({ bonus }) {
  const required = Number(bonus.wagering_required ?? 0);
  const done = Number(bonus.wagering_completed ?? 0);
  const pct = required > 0 ? Math.min(100, Math.round((done / required) * 100)) : 100;
  const tone = STATUS_TONE[bonus.status] ?? STATUS_TONE.expired;

  return (
    <article className="card-glass p-5">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <h2 className="font-semibold text-white">
            {bonus.title || SOURCE_LABEL[bonus.source] || 'Bonus'}
          </h2>
          <p className="mt-0.5 text-xs text-slate-500">
            {SOURCE_LABEL[bonus.source] ?? bonus.source}
            {bonus.created_at ? ` · ${formatDate(bonus.created_at)}` : ''}
          </p>
        </div>
        <div className="text-right">
          <p className="text-xl font-bold text-brand-300">{usdt(bonus.amount)}</p>
          <span
            className={`mt-1 inline-block rounded-full px-2.5 py-0.5 text-[0.65rem] font-semibold capitalize ${tone}`}
          >
            {bonus.status}
          </span>
        </div>
      </div>

      {required > 0 && (
        <div className="mt-4">
          <div className="flex items-center justify-between text-xs text-slate-400">
            <span>Wagering progress</span>
            <span>
              {usdt(done)} / {usdt(required)}
            </span>
          </div>
          <div
            className="mt-1.5 h-2 overflow-hidden rounded-full bg-white/[0.06]"
            role="progressbar"
            aria-valuenow={pct}
            aria-valuemin={0}
            aria-valuemax={100}
            aria-label="Wagering progress"
          >
            <div className="h-full rounded-full bg-brand-500 transition-all" style={{ width: `${pct}%` }} />
          </div>
          <p className="mt-1 text-[0.65rem] text-slate-500">
            {pct}% complete
            {bonus.expires_at ? ` · expires ${formatDate(bonus.expires_at)}` : ''}
          </p>
        </div>
      )}
    </article>
  );
}

function AvailableOffers({ offers, onClaimed }) {
  const [busyId, setBusyId] = useState(null);
  const [result, setResult] = useState(null);

  if (!offers.length) return null;

  const claim = async (offer) => {
    if (!offer.promo_code || offer.claimable === false) return;
    setBusyId(offer.id);
    setResult(null);
    try {
      const res = await api('/api/v1/bonuses/claim', {
        method: 'POST',
        body: JSON.stringify({ code: offer.promo_code }),
      });
      setResult({
        id: offer.id,
        ok: true,
        message: `${usdt(res.amount)} added — ${res.title}`,
      });
      onClaimed?.();
    } catch (err) {
      setResult({ id: offer.id, ok: false, message: err.message || 'Could not claim this offer.' });
    } finally {
      setBusyId(null);
    }
  };

  return (
    <div className="card-glass mt-6 p-5">
      <div className="flex items-center gap-2">
        <Sparkles className="h-4 w-4 text-brand-400" />
        <h2 className="text-base font-semibold text-white">Offers you can claim</h2>
      </div>

      <ul className="mt-3 space-y-2">
        {offers.map((offer) => (
          <li
            key={offer.id}
            className="flex flex-wrap items-center justify-between gap-3 rounded-xl border border-white/5 bg-white/[0.02] p-3"
          >
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-semibold text-white">{offer.title}</p>
              <p className="text-xs text-slate-500">
                {offer.value_type === 'percentage'
                  ? `${offer.value_amount}% bonus`
                  : usdt(offer.value_amount)}
                {offer.min_deposit > 0 && ` · min deposit ${usdt(offer.min_deposit)}`}
                {offer.wagering_multiplier > 0 && ` · ${offer.wagering_multiplier}× wagering`}
              </p>
              {offer.promo_code && (
                <p className="mt-0.5 font-mono text-[0.65rem] uppercase tracking-[0.15em] text-slate-500">
                  {offer.promo_code}
                </p>
              )}
              {offer.end_date && (
                <p className="mt-0.5 flex items-center gap-1 text-[0.65rem] text-slate-500">
                  <Clock className="h-3 w-3" /> Valid till {formatDate(offer.end_date)}
                </p>
              )}
              <OfferRequirements offer={offer} />
            </div>
            <OfferClaimButton
              offer={offer}
              busy={busyId === offer.id}
              onClaim={() => claim(offer)}
            />
          </li>
        ))}
      </ul>

      {result && (
        <div
          className={`mt-3 flex items-start gap-2 rounded-xl border p-3 ${
            result.ok
              ? 'border-emerald-500/20 bg-emerald-500/10'
              : 'border-red-500/20 bg-red-500/10'
          }`}
        >
          {result.ok ? (
            <Check className="mt-0.5 h-4 w-4 shrink-0 text-emerald-400" />
          ) : (
            <AlertCircle className="mt-0.5 h-4 w-4 shrink-0 text-red-400" />
          )}
          <p className={`text-sm font-semibold ${result.ok ? 'text-white' : 'text-red-400'}`}>
            {result.message}
          </p>
        </div>
      )}
    </div>
  );
}

function OfferRequirements({ offer }) {
  const reqs = Array.isArray(offer.requirements) ? offer.requirements : [];
  if (!reqs.length) return null;
  return (
    <ul className="mt-2 space-y-1.5">
      {reqs.map((req) => {
        const required = Number(req.required ?? 0);
        const current = Number(req.current ?? 0);
        const pct = required > 0 ? Math.min(100, Math.round((current / required) * 100)) : 100;
        return (
          <li key={req.key} className="min-w-[220px]">
            <div className="flex items-center justify-between gap-3 text-[0.65rem] font-semibold">
              <span className={req.met ? 'text-emerald-400' : 'text-slate-500'}>
                {req.met ? <Check className="mr-1 inline h-3 w-3" /> : <Lock className="mr-1 inline h-3 w-3" />}
                {req.label}
              </span>
              <span className="tabular-nums text-slate-300">
                {usdt(current)} / {usdt(required)}
              </span>
            </div>
            <div
              className="mt-1 h-1.5 overflow-hidden rounded-full bg-white/[0.06]"
              role="progressbar"
              aria-valuenow={pct}
              aria-valuemin={0}
              aria-valuemax={100}
              aria-label={req.label}
            >
              <div
                className={`h-full rounded-full transition-all ${req.met ? 'bg-emerald-500' : 'bg-brand-500'}`}
                style={{ width: `${pct}%` }}
              />
            </div>
          </li>
        );
      })}
    </ul>
  );
}

function OfferClaimButton({ offer, busy, onClaim }) {
  if (!offer.promo_code) {
    return <span className="shrink-0 text-xs font-semibold text-slate-500">Awarded automatically</span>;
  }
  if (offer.already_claimed) {
    return (
      <span className="inline-flex shrink-0 items-center gap-1 rounded-full bg-emerald-500/15 px-3 py-1 text-xs font-semibold text-emerald-400">
        <Check className="h-3.5 w-3.5" /> Claimed
      </span>
    );
  }
  const locked = offer.claimable === false;
  return (
    <div className="flex shrink-0 flex-col items-end gap-1">
      <button
        type="button"
        onClick={onClaim}
        disabled={busy || locked}
        title={locked ? offer.claim_blocked_reason || 'Requirements not met yet' : undefined}
        aria-disabled={busy || locked}
        className={`inline-flex items-center gap-1.5 ${t1Btn}`}
      >
        {locked && <Lock className="h-3.5 w-3.5" />}
        {busy ? 'Claiming…' : 'Claim'}
      </button>
      {locked && (
        <span className="max-w-[220px] text-right text-[0.65rem] font-semibold text-slate-500">
          {offer.requirements_met === false
            ? 'Unlocks when the conditions are met'
            : offer.claim_blocked_reason || 'Not available right now'}
        </span>
      )}
    </div>
  );
}
