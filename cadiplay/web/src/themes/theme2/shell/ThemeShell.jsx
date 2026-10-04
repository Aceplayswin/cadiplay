'use client';

// Theme 2 shell — "WAXCASINO": a fully distinct chrome from theme1. Left icon
// sidebar (expands on hover, drawer on mobile), sticky top bar, dark navy
// background, and a full footer. Pages render in the content slot; page-specific
// columns (e.g. the home chat / bet-slip rail) live in the page itself.

import { useState } from 'react';
import { usePathname } from 'next/navigation';
import { useWalletSync } from '@/hooks/useWalletSync';
import { isAccountRoute, HIDE_ON_MOBILE } from '@/lib/accountRoutes';
import { Theme2Sidebar } from './Sidebar';
import { Theme2TopBar } from './TopBar';
import { Theme2Footer } from './Footer';
import { Theme2AuthModals } from './AuthModals';

export default function Theme2Shell({ children }) {
  const pathname = usePathname();
  const [navOpen, setNavOpen] = useState(false);
  useWalletSync();

  // The admin console renders its own shell and must not inherit player chrome.
  if (pathname?.startsWith('/admin')) {
    return children;
  }

  const isPlayRoute = pathname?.startsWith('/play/');

  return (
    // `theme2-root` scopes theme2's dark palette regardless of the light/dark toggle.
    <div className="theme2-root min-h-screen bg-[#070d16] text-slate-200">
      <Theme2Sidebar open={navOpen} onClose={() => setNavOpen(false)} />

      {/* Content column offset by the collapsed sidebar on desktop. */}
      <div className="lg:pl-[88px]">
        <Theme2TopBar onMenu={() => setNavOpen(true)} />
        <main className="min-h-[calc(100vh-4rem)]">{children}</main>
        {!isPlayRoute && (
          <div className={isAccountRoute(pathname) ? HIDE_ON_MOBILE : undefined}>
            <Theme2Footer />
          </div>
        )}
      </div>
      <Theme2AuthModals />
    </div>
  );
}
