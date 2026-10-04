'use client';

// Theme4 Withdraw — shared wallet endpoints, teal style.

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { api } from '@/services/api';
import { useAuthStore } from '@/store/auth';
import { T4Card, t4Input, t4Select, t4BtnPrimary, T4FormPage } from '../components/ui';
import { formatAmountNumber, toStoredAmount } from '@/lib/money';

const REQUIRED_FIELDS = {
  bank_transfer: ['accountName', 'accountNumber', 'ifsc', 'bankName'],
  upi: ['upiId'],
  crypto: ['network', 'walletAddress'],
};

function Field({ label, hint, children }) {
  return (
    <label className="block">
      <span className="mb-1 block text-xs font-bold text-[#13272b]">{label}</span>
      {children}
      {hint && <span className="mt-1 block text-[0.7rem] text-[#8aa0a4]">{hint}</span>}
    </label>
  );
}

export default function Theme4Withdraw() {
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
    <T4FormPage
      title="Withdraw"
      subtitle={
        wallet
          ? `Withdrawable: USDT ${formatAmountNumber(withdrawable)}`
          : undefined
      }
    >
      <div className="mt-2 flex justify-end">
        <Link href="/deposit" className="text-sm font-bold text-[#0e7480] hover:underline">
          Deposit
        </Link>
      </div>

      <T4Card className="mt-6 p-6">
        {hasPending ? (
          <p className="mb-4 rounded border border-[#0e7480]/25 bg-[#eef6f7] px-3 py-2 text-xs font-semibold text-[#0e7480]">
            You have a withdrawal request awaiting approval. You can place a new request once it
            has been approved or rejected.
          </p>
        ) : null}
        {wallet?.bonus > 0 ? (
          <p className="mb-4 rounded border border-[#0e7480]/15 bg-[#eefafa] px-3 py-2 text-xs font-semibold text-[#5d7378]">
            Your USDT {formatAmountNumber(wallet.bonus)} bonus balance can be played
            with but not withdrawn. It becomes withdrawable once it meets its wagering requirement.
          </p>
        ) : null}
        <input
          type="number"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          placeholder="Amount"
          className={`${t4Input} text-2xl`}
        />
      </T4Card>

      <select
        value={method}
        onChange={(e) => {
          setMethod(e.target.value);
          setDestination({});
        }}
        className={`${t4Select} mt-4`}
      >
        <option value="bank_transfer">Bank Transfer</option>
        <option value="upi">UPI</option>
        <option value="crypto">Cryptocurrency</option>
      </select>

      <T4Card className="mt-4 space-y-3 p-5">
        {method === 'upi' && (
          <Field label="UPI ID" hint="For example name@okaxis">
            <input
              className={t4Input}
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
                className={t4Input}
                value={destination.accountName ?? ''}
                onChange={setField('accountName')}
                placeholder="As printed on the bank account"
              />
            </Field>
            <Field label="Account number">
              <input
                className={t4Input}
                value={destination.accountNumber ?? ''}
                onChange={setField('accountNumber')}
                inputMode="numeric"
                placeholder="Digits only"
                autoComplete="off"
              />
            </Field>
            <Field label="IFSC code">
              <input
                className={`${t4Input} uppercase`}
                value={destination.ifsc ?? ''}
                onChange={setField('ifsc')}
                placeholder="HDFC0001234"
                autoComplete="off"
              />
            </Field>
            <Field label="Bank Name">
              <input
                className={t4Input}
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
                className={t4Select}
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
                className={t4Input}
                value={destination.walletAddress ?? ''}
                onChange={setField('walletAddress')}
                placeholder="Destination wallet address"
                autoComplete="off"
                spellCheck={false}
              />
            </Field>
          </>
        )}
      </T4Card>

      <button
        type="button"
        onClick={submit}
        disabled={loading || hasPending || storedAmount < 500 || !destinationComplete}
        className={`${t4BtnPrimary} mt-6 w-full`}
      >
        {hasPending ? 'Withdrawal Pending Approval' : 'Request Withdrawal'}
      </button>
    </T4FormPage>
  );
}
