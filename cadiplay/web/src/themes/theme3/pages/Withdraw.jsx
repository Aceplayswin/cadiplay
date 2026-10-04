'use client';

// Theme3 Withdraw — shared wallet endpoints, cream style.

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { api } from '@/services/api';
import { useAuthStore } from '@/store/auth';
import { T3Card, t3Input, t3Select, t3BtnPrimary, T3FormPage } from '../components/ui';
import { formatAmountNumber, toStoredAmount } from '@/lib/money';

const REQUIRED_FIELDS = {
  bank_transfer: ['accountName', 'accountNumber', 'ifsc', 'bankName'],
  upi: ['upiId'],
  crypto: ['network', 'walletAddress'],
};

function Field({ label, hint, children }) {
  return (
    <label className="block">
      <span className="mb-1 block text-xs font-bold text-[#1b1726]">{label}</span>
      {children}
      {hint && <span className="mt-1 block text-[0.7rem] text-[#9a94a8]">{hint}</span>}
    </label>
  );
}

export default function Theme3Withdraw() {
  const router = useRouter();
  const { token, isHydrated, hydrate } = useAuthStore();
  const [wallet, setWallet] = useState(null);
  const [amount, setAmount] = useState('');
  const [method, setMethod] = useState('bank_transfer');
  const [destination, setDestination] = useState({});
  const [loading, setLoading] = useState(false);

  const setField = (key) => (e) =>
    setDestination((prev) => ({ ...prev, [key]: e.target.value }));

  const destinationComplete = REQUIRED_FIELDS[method].every(
    (key) => (destination[key] ?? '').trim() !== '',
  );

  const loadWallet = () => api('/api/v1/wallet').then(setWallet).catch(() => {});

  useEffect(() => {
    hydrate();
  }, [hydrate]);

  useEffect(() => {
    if (isHydrated && !token) router.replace('/login');
  }, [isHydrated, token, router]);

  useEffect(() => {
    if (token) loadWallet();
  }, [token]);

  const numAmount = parseFloat(amount) || 0;
  const storedAmount = toStoredAmount(numAmount);
  const withdrawable = wallet ? (wallet.withdrawable ?? wallet.available) : 0;
  const hasPending = Boolean(wallet?.hasPendingWithdrawal);

  const submit = async () => {
    setLoading(true);
    try {
      await api('/api/v1/wallet/withdraw', {
        method: 'POST',
        body: JSON.stringify({
          amount: storedAmount,
          paymentMethod: method,
          destination,
        }),
      });
      alert('Withdrawal request submitted — pending approval. The amount is held until our team approves or rejects it.');
      setAmount('');
    } catch (e) {
      alert(e instanceof Error ? e.message : 'Withdrawal failed');
    } finally {
      setLoading(false);
      loadWallet();
    }
  };

  return (
    <T3FormPage
      title="Withdraw"
      subtitle={
        wallet
          ? `Withdrawable: USDT ${formatAmountNumber(withdrawable)}`
          : undefined
      }
    >
      <div className="-mt-1 flex justify-end">
        <Link href="/deposit" className="text-sm font-bold text-[#9a7a24] hover:underline">
          Deposit
        </Link>
      </div>

      <T3Card className="mt-6 p-6">
        {hasPending ? (
          <p className="mb-4 rounded-xl border border-[#c79a3b]/30 bg-[#faf6ec] px-3 py-2 text-xs font-semibold text-[#9a7a24]">
            You have a withdrawal request awaiting approval. You can place a new request once it
            has been approved or rejected.
          </p>
        ) : null}
        {wallet?.bonus > 0 ? (
          <p className="mb-4 rounded-xl border border-[#c79a3b]/20 bg-[#faf6ec] px-3 py-2 text-xs font-semibold text-[#6b6579]">
            Your USDT {formatAmountNumber(wallet.bonus)} bonus balance can be played
            with but not withdrawn. It becomes withdrawable once it meets its wagering requirement.
          </p>
        ) : null}
        <input
          type="number"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          placeholder="Amount"
          className={`${t3Input} text-2xl`}
        />
      </T3Card>

      <select
        value={method}
        onChange={(e) => {
          setMethod(e.target.value);
          setDestination({});
        }}
        className={`${t3Select} mt-4`}
      >
        <option value="bank_transfer">Bank Transfer</option>
        <option value="upi">UPI</option>
        <option value="crypto">Cryptocurrency</option>
      </select>

      <T3Card className="mt-4 space-y-3 p-5">
        {method === 'upi' && (
          <Field label="UPI ID" hint="For example name@okaxis">
            <input
              className={t3Input}
              value={destination.upiId ?? ''}
              onChange={setField('upiId')}
              placeholder="name@bank"
              autoComplete="off"
            />
          </Field>
        )}

        {method === 'bank_transfer' && (
          <>
            <Field label="Account holder name">
              <input
                className={t3Input}
                value={destination.accountName ?? ''}
                onChange={setField('accountName')}
                placeholder="As printed on the bank account"
              />
            </Field>
            <Field label="Account number">
              <input
                className={t3Input}
                value={destination.accountNumber ?? ''}
                onChange={setField('accountNumber')}
                inputMode="numeric"
                placeholder="Digits only"
                autoComplete="off"
              />
            </Field>
            <Field label="IFSC code">
              <input
                className={`${t3Input} uppercase`}
                value={destination.ifsc ?? ''}
                onChange={setField('ifsc')}
                placeholder="HDFC0001234"
                autoComplete="off"
              />
            </Field>
            <Field label="Bank Name">
              <input
                className={t3Input}
                value={destination.bankName ?? ''}
                onChange={setField('bankName')}
                placeholder="e.g. HDFC Bank"
              />
            </Field>
          </>
        )}

        {method === 'crypto' && (
          <>
            <Field label="Network">
              <select
                className={t3Select}
                value={destination.network ?? ''}
                onChange={setField('network')}
              >
                <option value="">Select network</option>
                <option value="TRC20">USDT — TRC20</option>
                <option value="ERC20">USDT — ERC20</option>
                <option value="BEP20">USDT — BEP20</option>
              </select>
            </Field>
            <Field label="Wallet address" hint="Paid out to this address exactly as entered.">
              <input
                className={t3Input}
                value={destination.walletAddress ?? ''}
                onChange={setField('walletAddress')}
                placeholder="Destination wallet address"
                autoComplete="off"
                spellCheck={false}
              />
            </Field>
          </>
        )}
      </T3Card>

      <button
        type="button"
        onClick={submit}
        disabled={loading || hasPending || storedAmount < 500 || !destinationComplete}
        className={`${t3BtnPrimary} mt-6 w-full`}
      >
        {hasPending ? 'Withdrawal Pending Approval' : 'Request Withdrawal'}
      </button>
    </T3FormPage>
  );
}
