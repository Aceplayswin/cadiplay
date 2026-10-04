'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { api } from '@/services/api';
import { useAuthStore } from '@/store/auth';
import { formatDateTime } from '@/lib/datetime';
import { T2Card, t2BtnPrimary, t2BtnGhost } from '../components/ui';

const DASH = '—';

function Row({ label, value, children }) {
  return (
    <div className="flex items-center justify-between gap-4 border-b border-white/5 py-2.5 last:border-b-0">
      <span className="text-slate-400">{label}</span>
      {children ?? <span className="text-right text-white">{value ?? DASH}</span>}
    </div>
  );
}

function ReferralCard() {
  const [data, setData] = useState(null);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    let active = true;
    api('/api/v1/referral')
      .then((res) => active && setData(res))
      .catch(() => active && setData(null));
    return () => {
      active = false;
    };
  }, []);

  if (!data?.referral_code) return null;

  const copy = async () => {
    try {
      await navigator.clipboard.writeText(data.referral_code);
      setCopied(true);
      setTimeout(() => setCopied(false), 1500);
    } catch {
      // Clipboard unavailable.
    }
  };

  return (
    <T2Card className="mt-6 p-6">
      <h2 className="text-sm font-bold uppercase tracking-wide text-slate-400">Referrals</h2>
      <Row label="Your code">
        <span className="inline-flex items-center gap-2">
          <span className="font-mono tracking-[0.2em] text-white">{data.referral_code}</span>
          <button
            type="button"
            onClick={copy}
            className="rounded-lg border border-white/10 px-2.5 py-1 text-xs font-bold text-amber-400"
          >
            {copied ? 'Copied' : 'Copy'}
          </button>
        </span>
      </Row>
      <Row label="Players referred" value={String(data.referred_count ?? 0)} />
    </T2Card>
  );
}

export default function Theme2Profile() {
  const router = useRouter();
  const { token, user, username, logout, refreshSession } = useAuthStore();
  const [confirmingLogout, setConfirmingLogout] = useState(false);

  useEffect(() => {
    if (!token) {
      router.push('/login');
      return;
    }
    refreshSession();
  }, [token, router, refreshSession]);

  if (!token) return null;

  const region = [user?.state, user?.country_code?.toUpperCase()].filter(Boolean).join(', ');

  return (
    <div className="mx-auto max-w-2xl px-4 py-8">
      <h1 className="font-display text-2xl font-black text-white">Profile</h1>

      <T2Card className="mt-6 p-6">
        <h2 className="text-sm font-bold uppercase tracking-wide text-slate-400">Account details</h2>
        <Row label="Full name" value={user?.full_name} />
        <Row label="Username" value={user?.username || username} />
        <Row label="Phone" value={user?.phone} />
        <Row label="Player ID" value={user?.id} />
        <Row label="Region" value={region || DASH} />
        <Row label="Member since" value={formatDateTime(user?.created_at, DASH)} />
        <Row label="Last login" value={formatDateTime(user?.last_login_at, DASH)} />
      </T2Card>

      <T2Card className="mt-6 p-6">
        <h2 className="text-sm font-bold uppercase tracking-wide text-slate-400">Security</h2>
        <Row label="Password">
          <Link href="/change-password" className="text-sm font-bold text-amber-400 hover:underline">
            Change
          </Link>
        </Row>
      </T2Card>

      <ReferralCard />

      <div className="mt-8 flex flex-wrap gap-3">
        <Link href="/deposit" className={`${t2BtnPrimary} text-sm`}>Deposit</Link>
        <Link href="/withdraw" className={`${t2BtnGhost} text-sm`}>Withdraw</Link>
        <Link href="/transactions" className={`${t2BtnGhost} text-sm`}>Transactions</Link>
        <Link href="/bet-history" className={`${t2BtnGhost} text-sm`}>Bet History</Link>
        <Link href="/bonus" className={`${t2BtnGhost} text-sm`}>Bonuses</Link>
        <Link href="/support/chat" className={`${t2BtnGhost} text-sm`}>Support</Link>
      </div>

      <div className="mt-8">
        {confirmingLogout ? (
          <T2Card className="border-red-500/20 p-5">
            <p className="font-bold text-white">Log out of your account?</p>
            <p className="mt-1 text-sm text-slate-400">You&apos;ll need to sign in again to place bets or withdraw.</p>
            <div className="mt-4 flex flex-wrap gap-2">
              <button type="button" onClick={logout} className="rounded-xl bg-red-500 px-5 py-2.5 text-sm font-bold text-white">
                Yes, log out
              </button>
              <button type="button" onClick={() => setConfirmingLogout(false)} className={t2BtnGhost}>
                Cancel
              </button>
            </div>
          </T2Card>
        ) : (
          <button type="button" onClick={() => setConfirmingLogout(true)} className="text-sm text-red-400 hover:underline">
            Log out
          </button>
        )}
      </div>
    </div>
  );
}
