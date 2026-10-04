'use client';

// Theme1 App install — dark glass. Two routes:
//   • PWA — Chromium one-tap install via useInstallPrompt; iOS gets Share steps.
//   • APK — shown only when admin has published a build at /api/v1/app/apk.

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { Check, Download, Plus, Share, Smartphone } from 'lucide-react';
import { API_URL } from '@/services/tenant';
import { api } from '@/services/api';
import { useBranding } from '@/hooks/useBranding';
import { useInstallPrompt } from '@/hooks/useInstallPrompt';

const PERKS = [
  'Full-screen play — no browser bars',
  'Launches from your home screen in one tap',
  'Faster loads and smoother live tables',
  'Instant alerts for deposits, withdrawals and bet results',
];

export default function Theme1AppDownload() {
  const branding = useBranding();
  const { canPrompt, promptInstall, isIOS, isStandalone } = useInstallPrompt();
  const [config, setConfig] = useState(null);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    let active = true;
    api('/api/v1/app/download')
      .then((data) => active && setConfig(data))
      .catch(() => active && setConfig(null))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, []);

  const name = branding.product_name || 'Cadiplay';
  const apkAvailable = config?.available;
  const downloadUrl = `${API_URL}/api/v1/app/apk`;

  const handleInstall = async () => {
    setBusy(true);
    await promptInstall();
    setBusy(false);
  };

  return (
    <main className="mx-auto max-w-4xl flex-1 px-4 py-10">
      <div className="card-glass relative overflow-hidden p-8 sm:p-10">
        <div className="pointer-events-none absolute -right-10 -top-12 h-48 w-48 rounded-full bg-brand-500/10 blur-3xl" />

        <span className="inline-flex items-center gap-1.5 rounded-full bg-brand-500/15 px-3 py-1 text-xs font-semibold text-brand-300">
          <Smartphone className="h-3.5 w-3.5" /> Mobile app
        </span>

        <h1 className="mt-4 text-3xl font-extrabold sm:text-4xl">Install {name}</h1>
        <p className="mt-2 max-w-xl text-sm text-slate-400">
          Add it to your home screen for the fastest way to play, deposit and track your
          bets. It installs free — no app store needed.
        </p>

        <div className="mt-8">
          {isStandalone ? (
            <div className="rounded-xl border border-white/10 bg-white/[0.02] p-5 text-center">
              <Check className="mx-auto mb-1 h-6 w-6 text-emerald-400" />
              <p className="text-sm font-semibold text-white">You&apos;re already using the app</p>
              <p className="mt-0.5 text-sm text-slate-400">
                Launch it any time from your home screen.
              </p>
            </div>
          ) : canPrompt ? (
            <button
              type="button"
              onClick={handleInstall}
              disabled={busy}
              className="inline-flex items-center gap-2 rounded-xl bg-brand-500 px-7 py-3.5 font-semibold text-surface-900 shadow-lg shadow-brand-500/20 transition hover:bg-brand-400 disabled:opacity-60"
            >
              <Download className="h-5 w-5" />
              {busy ? 'Installing…' : 'Install app'}
            </button>
          ) : isIOS ? (
            <IOSSteps />
          ) : (
            <GenericSteps />
          )}
        </div>

        {!isStandalone && (
          <ul className="mt-8 grid gap-3 sm:grid-cols-2">
            {PERKS.map((perk) => (
              <li key={perk} className="flex items-start gap-2 text-sm text-slate-300">
                <Check className="mt-0.5 h-4 w-4 shrink-0 text-brand-400" />
                {perk}
              </li>
            ))}
          </ul>
        )}
      </div>

      {loading ? (
        <div className="mt-5 h-24 animate-pulse rounded-xl bg-white/[0.04]" />
      ) : apkAvailable ? (
        <section className="card-glass mt-5 p-6">
          <h2 className="text-sm font-semibold uppercase tracking-wide text-slate-400">
            Android APK
          </h2>
          <p className="mt-1 text-sm text-slate-400">
            Prefer the native Android build? Download it directly.
          </p>

          <a
            href={downloadUrl}
            className="mt-4 inline-flex items-center gap-2 rounded-xl bg-emerald-500 px-6 py-3 text-sm font-semibold text-surface-900 transition hover:bg-emerald-400"
          >
            <Download className="h-4 w-4" /> Download APK
          </a>

          <dl className="mt-4 flex flex-wrap gap-x-8 gap-y-2 text-xs text-slate-400">
            {config.version && <Meta label="Version" value={config.version} />}
            {config.size_mb && <Meta label="Size" value={`${config.size_mb} MB`} />}
            {config.min_android && (
              <Meta label="Requires" value={`Android ${config.min_android}+`} />
            )}
          </dl>

          {config.release_notes && (
            <p className="mt-4 whitespace-pre-line rounded-xl border border-white/5 bg-white/[0.02] p-4 text-xs text-slate-400">
              {config.release_notes}
            </p>
          )}

          {config.ios_url && (
            <p className="mt-4 text-sm text-slate-400">
              On iPhone?{' '}
              <a href={config.ios_url} className="text-brand-400 hover:underline">
                Install for iOS
              </a>
            </p>
          )}

          <ol className="mt-5 space-y-2 border-t border-white/10 pt-5 text-sm text-slate-300">
            <Step n={1}>Tap “Download APK” and wait for the file to finish.</Step>
            <Step n={2}>
              Open it. If Android asks, allow installs from this source — that prompt is
              normal for apps outside the Play Store.
            </Step>
            <Step n={3}>Tap Install, then open the app and sign in as usual.</Step>
          </ol>
        </section>
      ) : null}

      <p className="mt-5 text-center text-sm text-slate-500">
        Everything also works in your mobile browser —{' '}
        <Link href="/" className="font-semibold text-brand-400 hover:underline">
          start playing
        </Link>
        .
      </p>
    </main>
  );
}

function Meta({ label, value }) {
  return (
    <div>
      <dt className="uppercase tracking-wide text-slate-500">{label}</dt>
      <dd className="mt-0.5 font-semibold text-slate-200">{value}</dd>
    </div>
  );
}

function Step({ n, children }) {
  return (
    <li className="flex gap-3">
      <span className="grid h-6 w-6 shrink-0 place-items-center rounded-full bg-brand-500/15 text-xs font-bold text-brand-300">
        {n}
      </span>
      <span>{children}</span>
    </li>
  );
}

function Pill({ icon: Icon, label }) {
  return (
    <span className="inline-flex items-center gap-1 rounded-md border border-white/10 bg-white/5 px-1.5 py-0.5 text-xs font-bold text-white">
      <Icon className="h-3.5 w-3.5" /> {label}
    </span>
  );
}

function IOSSteps() {
  return (
    <div className="rounded-xl border border-white/10 bg-white/[0.02] p-4">
      <p className="mb-3 flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wide text-slate-400">
        <Smartphone className="h-3.5 w-3.5" /> Install on iPhone or iPad (Safari)
      </p>
      <ol className="space-y-2.5">
        <Step n={1}>
          <span className="flex flex-wrap items-center gap-1.5">
            Tap the <Pill icon={Share} label="Share" /> button in Safari&apos;s toolbar.
          </span>
        </Step>
        <Step n={2}>
          <span className="flex flex-wrap items-center gap-1.5">
            Choose <Pill icon={Plus} label="Add to Home Screen" />.
          </span>
        </Step>
        <Step n={3}>Tap “Add” — the icon appears on your home screen.</Step>
      </ol>
    </div>
  );
}

function GenericSteps() {
  return (
    <div className="rounded-xl border border-white/10 bg-white/[0.02] p-4">
      <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-slate-400">
        Install from your browser
      </p>
      <p className="text-sm text-slate-300">
        Open your browser menu and choose{' '}
        <span className="font-semibold text-white">“Install app”</span> or{' '}
        <span className="font-semibold text-white">“Add to Home Screen”</span>. On desktop
        Chrome or Edge, look for the install icon at the end of the address bar.
      </p>
    </div>
  );
}
