'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { api } from '@/services/api';
import { useAuthStore } from '@/store/auth';
import { formatDateTime } from '@/lib/datetime';
import { T3Card, t3BtnPrimary, t3BtnOutline, T3FormPage } from '../components/ui';

const DASH = '—';

function Row({ label, value, children }) {
  return (
    <div className="flex items-center justify-between gap-4 border-b border-black/[0.06] py-2.5 last:border-b-0">
      <span className="text-[#6b6579]">{label}</span>
      {children ?? <span className="font-bold text-[#1b1726]">{value ?? DASH}</span>}
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
    <T3Card className="mt-6 p-6">
      <h2 className="text-sm font-black uppercase tracking-wide text-[#6b6579]">Referrals</h2>
      <Row label="Your code">
        <span className="inline-flex items-center gap-2">
          <span className="font-mono tracking-[0.2em] text-[#1b1726]">{data.referral_code}</span>
          <button
            type="button"
            onClick={copy}
            className="rounded-lg border border-black/10 px-2.5 py-1 text-xs font-bold text-[#9a7a24]"
          >
            {copied ? 'Copied' : 'Copy'}
          </button>
        </span>
      </Row>
      <Row label="Players referred" value={String(data.referred_count ?? 0)} />
    </T3Card>
  );
}

export default function Theme3Profile() {
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
    <T3FormPage title="Profile">
      <T3Card className="mt-6 p-6">
        <h2 className="text-sm font-black uppercase tracking-wide text-[#6b6579]">Account details</h2>
        <Row label="Full name" value={user?.full_name} />
        <Row label="Username" value={user?.username || username} />
        <Row label="Phone" value={user?.phone} />
        <Row label="Player ID" value={user?.id} />
        <Row label="Region" value={region || DASH} />
        <Row label="Member since" value={formatDateTime(user?.created_at, DASH)} />
        <Row label="Last login" value={formatDateTime(user?.last_login_at, DASH)} />
      </T3Card>

      <T3Card className="mt-6 p-6">
        <h2 className="text-sm font-black uppercase tracking-wide text-[#6b6579]">Security</h2>
        <Row label="Password">
          <Link href="/change-password" className="text-sm font-bold text-[#9a7a24] hover:underline">
            Change
          </Link>
        </Row>
      </T3Card>

      <ReferralCard />

      <div className="mt-8 flex flex-wrap gap-3">
        <Link href="/deposit" className={`${t3BtnPrimary} text-sm`}>Deposit</Link>
        <Link href="/withdraw" className={`${t3BtnOutline} text-sm`}>Withdraw</Link>
        <Link href="/transactions" className={`${t3BtnOutline} text-sm`}>Transactions</Link>
        <Link href="/bet-history" className={`${t3BtnOutline} text-sm`}>Bet History</Link>
        <Link href="/bonus" className={`${t3BtnOutline} text-sm`}>Bonuses</Link>
        <Link href="/support/chat" className={`${t3BtnOutline} text-sm`}>Support</Link>
      </div>

      <div className="mt-8">
        {confirmingLogout ? (
          <T3Card className="border-[#e5484d]/25 p-5">
            <p className="font-black text-[#1b1726]">Log out of your account?</p>
            <p className="mt-1 text-sm text-[#6b6579]">You&apos;ll need to sign in again to place bets or withdraw.</p>
            <div className="mt-4 flex flex-wrap gap-2">
              <button type="button" onClick={logout} className="rounded-xl bg-[#e5484d] px-5 py-2.5 text-sm font-bold text-white">
                Yes, log out
              </button>
              <button type="button" onClick={() => setConfirmingLogout(false)} className={t3BtnOutline}>
                Cancel
              </button>
            </div>
          </T3Card>
        ) : (
          <button type="button" onClick={() => setConfirmingLogout(true)} className="text-sm text-[#e5484d] hover:underline">
            Log out
          </button>
        )}
      </div>
    </T3FormPage>
  );
}
