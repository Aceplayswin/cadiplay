'use client';

// Theme4 Deposit — same data flow as theme2/3 (shared wallet endpoints), teal
// style. Methods come from the admin console; the block under the chosen one
// is decided by its TYPE (UPI: QR + ID, bank: account, crypto: wallet address).

import { useEffect, useRef, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Upload, X, Check, Loader2 } from 'lucide-react';
import { api, upload } from '@/services/api';
import { affiliateAttribution } from '@/lib/referral';
import { useAuthStore } from '@/store/auth';
import { useDepositMethods } from '@/hooks/useDepositMethods';
import { ReceivingDetails } from '@/components/payments/ReceivingDetails';
import { amountWithinLimits, hasDestination, methodDescription } from '@/lib/paymentDestination';
import { T4Card, t4Input, t4BtnPrimary, T4FormPage } from '../components/ui';
import { formatAmountNumber, toDisplayAmount, toStoredAmount } from '@/lib/money';

const QUICK_AMOUNTS = [500, 1000, 2500, 5000, 10000];
const MAX_PROOF_BYTES = 5 * 1024 * 1024;
const PROOF_TYPES = ['image/png', 'image/jpeg', 'image/webp'];

// Theme4 (teal) palette for the shared "send payment to" block.
const RECEIVING_STYLES = {
  card: '',
  title: 'font-black text-[#13272b]',
  note: 'mt-1 text-xs text-[#8aa0a4]',
  rows: 'mt-4 space-y-2',
  row: 'flex items-center justify-between gap-3 rounded border border-black/10 bg-white px-4 py-3',
  label: 'text-[0.65rem] font-black uppercase tracking-wide text-[#8aa0a4]',
  value: 'break-all font-bold text-[#13272b]',
  mono: 'font-mono text-sm',
  copyBtn:
    'shrink-0 rounded border border-[#0e7480]/25 px-3 py-1.5 text-xs font-bold text-[#0e7480] transition hover:border-[#0e7480] hover:bg-[#eef6f7]',
  qrFrame: 'mt-4 flex justify-center',
  qrImg: 'h-44 w-44 max-w-full rounded border border-black/10 bg-white object-contain p-1',
  instructions: 'mt-4 whitespace-pre-line rounded bg-[#eef6f7] p-3 text-xs text-[#13272b]',
};

export default function Theme4Deposit() {
  const router = useRouter();
  const { token, isHydrated, hydrate } = useAuthStore();
  const [amount, setAmount] = useState('');
  const [method, setMethod] = useState('');
  const [reference, setReference] = useState('');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState(null);
  const [submitError, setSubmitError] = useState('');
  const [proofFile, setProofFile] = useState(null);
  const [proofPreview, setProofPreview] = useState('');
  const [proofUrl, setProofUrl] = useState('');
  const [proofError, setProofError] = useState('');
  const [uploading, setUploading] = useState(false);
  const fileInputRef = useRef(null);
  const {
    methods,
    loading: methodsLoading,
    error: methodsError,
  } = useDepositMethods(isHydrated && Boolean(token));

  const numAmount = parseFloat(amount) || 0;
  const storedAmount = toStoredAmount(numAmount);
  const selected = methods.find((m) => m.code === method) ?? null;
  const needsProof = Boolean(selected);
  const limit = amountWithinLimits(selected, storedAmount);
  const canSubmit =
    !loading &&
    !uploading &&
    storedAmount > 0 &&
    Boolean(selected) &&
    limit.ok &&
    (!needsProof || Boolean(proofUrl));

  useEffect(() => {
    hydrate();
  }, [hydrate]);

  useEffect(() => {
    if (isHydrated && !token) router.replace('/login');
  }, [isHydrated, token, router]);

  // A method the admin has since disabled must not stay selected.
  useEffect(() => {
    if (method && !methods.some((m) => m.code === method)) setMethod('');
  }, [methods, method]);

  useEffect(() => {
    setReference('');
    setSubmitError('');
    setProofFile(null);
    setProofPreview('');
    setProofUrl('');
    setProofError('');
    if (fileInputRef.current) fileInputRef.current.value = '';
  }, [method]);

  useEffect(() => {
    if (!proofPreview) return undefined;
    return () => URL.revokeObjectURL(proofPreview);
  }, [proofPreview]);

  const pickProof = async (file) => {
    if (!file) return;
    setProofError('');
    setProofUrl('');
    if (!PROOF_TYPES.includes(file.type)) {
      setProofError('Upload a PNG, JPG or WEBP image.');
      return;
    }
    if (file.size > MAX_PROOF_BYTES) {
      setProofError('Screenshot too large (max 5MB).');
      return;
    }
    setProofFile(file);
    setProofPreview(URL.createObjectURL(file));
    setUploading(true);
    try {
      const res = await upload('/api/v1/wallet/deposit/proof', file);
      setProofUrl(res.url);
    } catch (e) {
      setProofError(e instanceof Error ? e.message : 'Upload failed');
      setProofFile(null);
      setProofPreview('');
    } finally {
      setUploading(false);
    }
  };

  const clearProof = () => {
    setProofFile(null);
    setProofPreview('');
    setProofUrl('');
    setProofError('');
    if (fileInputRef.current) fileInputRef.current.value = '';
  };

  const submit = async () => {
    if (!selected) return;
    setLoading(true);
    setSubmitError('');
    try {
      const res = await api('/api/v1/wallet/deposit', {
        method: 'POST',
        body: JSON.stringify({
          amount: storedAmount,
          paymentMethod: selected.code,
          referenceNumber: reference.trim() || null,
          paymentProofUrl: proofUrl || null,
          ...affiliateAttribution(),
        }),
      });
      setResult(res);
      setAmount('');
      setReference('');
      clearProof();
    } catch (e) {
      const msg = e instanceof Error ? e.message : 'Deposit failed';
      if (/log in again|unauthorized/i.test(msg)) {
        router.replace('/login');
        return;
      }
      setSubmitError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <T4FormPage title="Deposit">
      <div className="mt-2 flex justify-end">
        <Link href="/withdraw" className="text-sm font-bold text-[#0e7480] hover:underline">
          Withdrawals
        </Link>
      </div>

      <T4Card className="mt-6 p-6">
        <label className="text-sm text-[#5d7378]">Enter Amount (USDT)</label>
        <input
          type="number"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          placeholder="0"
          className={`${t4Input} mt-2 text-2xl`}
        />
        <div className="mt-4 flex flex-wrap gap-2">
          {QUICK_AMOUNTS.map((a) => (
            <button
              key={a}
              type="button"
              onClick={() => setAmount(String(toDisplayAmount(a)))}
              className="rounded border border-[#0e7480]/25 bg-white px-4 py-2 text-sm text-[#13272b] shadow-sm transition hover:border-[#0e7480] hover:text-[#0e7480]"
            >
              USDT {formatAmountNumber(a)}
            </button>
          ))}
        </div>
      </T4Card>

      <T4Card className="mt-6 p-6">
        <h2 className="font-black text-[#13272b]">Payment Method</h2>
        {methodsLoading ? (
          <p className="mt-4 text-sm text-[#8aa0a4]">Loading payment methods…</p>
        ) : methods.length === 0 ? (
          <p className="mt-4 rounded border border-black/10 bg-white p-4 text-sm text-[#5d7378]">
            {methodsError
              ? 'Payment methods are temporarily unavailable. Please try again shortly.'
              : 'No payment methods are available right now. Please contact support.'}
          </p>
        ) : (
          <div className="mt-4 space-y-2">
            {methods.map((pm) => (
              <label
                key={pm.code}
                className={`flex cursor-pointer items-center gap-3 rounded border p-4 transition ${
                  method === pm.code ? 'border-[#0e7480] bg-[#eef6f7]' : 'border-black/10 bg-white'
                }`}
              >
                <input
                  type="radio"
                  name="method"
                  value={pm.code}
                  checked={method === pm.code}
                  onChange={() => setMethod(pm.code)}
                  className="accent-[#0e7480]"
                />
                <div className="min-w-0">
                  <p className="font-bold text-[#13272b]">{pm.name}</p>
                  <p className="text-xs text-[#8aa0a4]">{methodDescription(pm)}</p>
                </div>
              </label>
            ))}
          </div>
        )}
        {selected && numAmount > 0 && !limit.ok && (
          <p className="mt-3 text-sm font-bold text-[#b45309]">{limit.message}</p>
        )}
      </T4Card>

      {selected && hasDestination(selected) && (
        <T4Card className="mt-6 p-6">
          <ReceivingDetails
            method={selected}
            styles={RECEIVING_STYLES}
            note="Transfer the amount to this account, then upload your payment proof below."
          />
        </T4Card>
      )}

      {needsProof && (
        <T4Card className="mt-6 p-6">
          <h2 className="font-black text-[#13272b]">Payment proof</h2>
          <p className="mt-1 text-xs text-[#8aa0a4]">
            Pay using {selected.name}, then upload a screenshot of the completed payment.
            Our team verifies it and credits your wallet.
          </p>

          <label className="mt-4 block text-sm text-[#5d7378]">
            UTR / Reference number <span className="text-[#8aa0a4]">(optional)</span>
          </label>
          <input
            type="text"
            value={reference}
            onChange={(e) => {
              setReference(e.target.value);
              if (submitError) setSubmitError('');
            }}
            placeholder="e.g. 412345678901"
            className={`${t4Input} mt-2`}
          />
          {submitError ? <p className="mt-2 text-sm text-red-500">{submitError}</p> : null}

          <label className="mt-4 block text-sm text-[#5d7378]">Screenshot</label>
          <input
            ref={fileInputRef}
            type="file"
            accept="image/png,image/jpeg,image/webp"
            onChange={(e) => pickProof(e.target.files?.[0])}
            className="hidden"
          />

          {!proofPreview ? (
            <button
              type="button"
              onClick={() => fileInputRef.current?.click()}
              className="mt-2 flex w-full flex-col items-center gap-2 rounded border-2 border-dashed border-[#0e7480]/25 bg-white px-4 py-8 text-center transition hover:border-[#0e7480]"
            >
              <Upload className="h-6 w-6 text-[#0e7480]" />
              <span className="text-sm font-bold text-[#13272b]">Tap to upload your payment screenshot</span>
              <span className="text-xs text-[#8aa0a4]">PNG, JPG or WEBP · up to 5MB</span>
            </button>
          ) : (
            <div className="mt-2 rounded border border-black/10 bg-white p-3">
              <div className="flex items-start gap-3">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src={proofPreview}
                  alt="Payment screenshot preview"
                  className="h-24 w-24 shrink-0 rounded border border-black/10 object-cover"
                />
                <div className="min-w-0 flex-1">
                  <p className="truncate text-sm font-bold text-[#13272b]">{proofFile?.name}</p>
                  <p className="mt-0.5 text-xs text-[#8aa0a4]">
                    {((proofFile?.size ?? 0) / 1024).toFixed(0)} KB
                  </p>
                  {uploading && (
                    <p className="mt-1 flex items-center gap-1.5 text-xs font-bold text-[#0e7480]">
                      <Loader2 className="h-3.5 w-3.5 animate-spin" /> Uploading…
                    </p>
                  )}
                  {proofUrl && !uploading && (
                    <p className="mt-1 flex items-center gap-1.5 text-xs font-bold text-[#1c8a52]">
                      <Check className="h-3.5 w-3.5" /> Uploaded
                    </p>
                  )}
                </div>
                <button
                  type="button"
                  onClick={clearProof}
                  aria-label="Remove screenshot"
                  className="rounded p-1 text-[#8aa0a4] transition hover:bg-black/5 hover:text-[#13272b]"
                >
                  <X className="h-4 w-4" />
                </button>
              </div>
            </div>
          )}
          {proofError && <p className="mt-2 text-xs font-bold text-red-500">{proofError}</p>}
        </T4Card>
      )}

      <button type="button" onClick={submit} disabled={!canSubmit} className={`${t4BtnPrimary} mt-6 w-full`}>
        {loading ? 'Processing...' : uploading ? 'Uploading screenshot…' : 'Submit deposit request'}
      </button>
      {needsProof && !proofUrl && !uploading && (
        <p className="mt-2 text-center text-xs text-[#8aa0a4]">Upload your payment screenshot to submit.</p>
      )}
      {result && (
        <div className="mt-4 rounded border border-[#0e7480]/30 bg-[#eefafa] p-4 text-center">
          <p className="text-sm font-black text-[#0e7480]">Deposit submitted — pending approval</p>
          <p className="mt-1 text-xs text-slate-500">
            Request ID: {result.transactionId}. Our team is reviewing your payment proof —
            your wallet is credited once it is approved.
          </p>
        </div>
      )}
    </T4FormPage>
  );
}
