'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { api } from '@/services/api';
import { useAuthStore } from '@/store/auth';
import { formatDateTime } from '@/lib/datetime';
import { T4Card, t4BtnPrimary, t4BtnOutline, T4FormPage } from '../components/ui';

const DASH = '—';

function Row({ label, value, children }) {
  return (
    <div className="flex items-center justify-between gap-4 border-b border-black/[0.06] py-2.5 last:border-b-0">
      <span className="text-[#5d7378]">{label}</span>
      {children ?? <span className="font-bold text-[#13272b]">{value ?? DASH}</span>}
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
    <T4Card className="mt-6 p-6">
      <h2 className="text-sm font-black uppercase tracking-wide text-[#5d7378]">Referrals</h2>
      <Row label="Your code">
        <span className="inline-flex items-center gap-2">
          <span className="font-mono tracking-[0.2em] text-[#13272b]">{data.referral_code}</span>
          <button
            type="button"
            onClick={copy}
            className="rounded border border-[#0e7480]/25 px-2.5 py-1 text-xs font-bold text-[#0e7480]"
          >
            {copied ? 'Copied' : 'Copy'}
          </button>
        </span>
      </Row>
      <Row label="Players referred" value={String(data.referred_count ?? 0)} />
    </T4Card>
  );
}

export default function Theme4Profile() {
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
    <T4FormPage title="Profile">
      <T4Card className="mt-6 p-6">
        <h2 className="text-sm font-black uppercase tracking-wide text-[#5d7378]">Account details</h2>
        <Row label="Full name" value={user?.full_name} />
        <Row label="Username" value={user?.username || username} />
        <Row label="Phone" value={user?.phone} />
        <Row label="Player ID" value={user?.id} />
        <Row label="Region" value={region || DASH} />
        <Row label="Member since" value={formatDateTime(user?.created_at, DASH)} />
        <Row label="Last login" value={formatDateTime(user?.last_login_at, DASH)} />
      </T4Card>

      <T4Card className="mt-6 p-6">
        <h2 className="text-sm font-black uppercase tracking-wide text-[#5d7378]">Security</h2>
        <Row label="Password">
          <Link href="/change-password" className="text-sm font-bold text-[#0e7480] hover:underline">
            Change
          </Link>
        </Row>
      </T4Card>

      <ReferralCard />

      <div className="mt-8 flex flex-wrap gap-3">
        <Link href="/deposit" className={`${t4BtnPrimary} text-sm`}>Deposit</Link>
        <Link href="/withdraw" className={`${t4BtnOutline} text-sm`}>Withdraw</Link>
        <Link href="/transactions" className={`${t4BtnOutline} text-sm`}>Transactions</Link>
        <Link href="/bet-history" className={`${t4BtnOutline} text-sm`}>Bet History</Link>
        <Link href="/bonus" className={`${t4BtnOutline} text-sm`}>Bonuses</Link>
        <Link href="/support/chat" className={`${t4BtnOutline} text-sm`}>Support</Link>
      </div>

      <div className="mt-8">
        {confirmingLogout ? (
          <T4Card className="border-[#e5342c]/25 p-5">
            <p className="font-black text-[#13272b]">Log out of your account?</p>
            <p className="mt-1 text-sm text-[#5d7378]">You&apos;ll need to sign in again to place bets or withdraw.</p>
            <div className="mt-4 flex flex-wrap gap-2">
              <button type="button" onClick={logout} className="rounded bg-[#e5342c] px-5 py-2.5 text-sm font-bold text-white">
                Yes, log out
              </button>
              <button type="button" onClick={() => setConfirmingLogout(false)} className={t4BtnOutline}>
                Cancel
              </button>
            </div>
          </T4Card>
        ) : (
          <button type="button" onClick={() => setConfirmingLogout(true)} className="text-sm text-[#e5342c] hover:underline">
            Log out
          </button>
        )}
      </div>
    </T4FormPage>
  );
}
