'use client';

// Theme3 shell — "VELPLAY": a light cream lobby. Distinct chrome from theme1/2:
// a floating top-nav pill bar + a secondary category pill bar, cream page surface,
// and a dark-purple footer. Auth is presented as split-panel modals owned here, so
// the top-nav buttons and the /login + /register routes can open them.
//
// The whole tree is scoped with `theme3-root` so the cream palette holds regardless
// of the app-wide light/dark toggle (mirrors theme2's dark scoping).

import { useCallback, useMemo, useState } from 'react';
import { usePathname } from 'next/navigation';
import { useWalletSync } from '@/hooks/useWalletSync';
import { isAccountRoute, HIDE_ON_MOBILE } from '@/lib/accountRoutes';
import { Theme3TopNav } from './TopNav';
import { Theme3CategoryBar } from './CategoryBar';
import { Theme3Footer } from './Footer';
import { Theme3AuthModals } from './AuthModals';
import { Theme3AuthModalContext } from './authModalContext';

export default function Theme3Shell({ children }) {
  const pathname = usePathname();
  const [authMode, setAuthMode] = useState(null); // null | 'login' | 'register'

  const open = useCallback((mode) => setAuthMode(mode), []);
  const close = useCallback(() => setAuthMode(null), []);
  const modalValue = useMemo(() => ({ mode: authMode, open, close }), [authMode, open, close]);
  useWalletSync();

  // The admin console renders its own shell and must not inherit player chrome.
  if (pathname?.startsWith('/admin')) {
    return children;
  }

  const isPlayRoute = pathname?.startsWith('/play/');

  return (
    <Theme3AuthModalContext.Provider value={modalValue}>
      <div className="theme3-root min-h-screen">
        <Theme3TopNav />
        {!isPlayRoute && (
          <div className={isAccountRoute(pathname) ? HIDE_ON_MOBILE : undefined}>
            <Theme3CategoryBar />
          </div>
        )}
        <main className="min-h-[60vh]">{children}</main>
        {!isPlayRoute && (
          <div className={isAccountRoute(pathname) ? HIDE_ON_MOBILE : undefined}>
            <Theme3Footer />
          </div>
        )}
        <Theme3AuthModals />
      </div>
    </Theme3AuthModalContext.Provider>
  );
}
