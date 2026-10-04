'use client';

import { createContext, useContext, useEffect, useMemo, useState } from 'react';
import { fetchBranding } from '../services/tenant';

// Neutral default so the UI never hardcodes a brand and never flashes a wrong name.
const DEFAULT_BRANDING = {
  product_name: '',
  logo_url: '',
  favicon_url: '',
};

// Point the tab icon at the brand's favicon, so each white-label shows its own
// mark instead of the bundled default. Next emits a <link rel="icon"> from the
// app/favicon.ico file convention where one exists, so that link is repointed;
// where it doesn't, the link is created.
function applyFavicon(faviconUrl) {
  if (typeof document === 'undefined' || !faviconUrl) return;
  const links = document.querySelectorAll("link[rel~='icon']");
  if (links.length) {
    links.forEach((l) => {
      l.href = faviconUrl;
      // The sizes/type hints described the bundled default, not this file.
      l.removeAttribute('sizes');
      l.removeAttribute('type');
    });
    return;
  }
  const link = document.createElement('link');
  link.rel = 'icon';
  link.href = faviconUrl;
  document.head.appendChild(link);
}

const BrandContext = createContext(DEFAULT_BRANDING);

export function useBranding() {
  return useContext(BrandContext);
}

export function BrandProvider({ children }) {
  const [branding, setBranding] = useState(DEFAULT_BRANDING);

  useEffect(() => {
    let active = true;
    fetchBranding()
      .then((data) => {
        if (!active || !data) return;
        setBranding({ ...DEFAULT_BRANDING, ...data });
        if (data.product_name) {
          document.title = `${data.product_name} Affiliates`;
        }
        applyFavicon(data.favicon_url || data.logo_url);
      })
      .catch(() => {});
    return () => {
      active = false;
    };
  }, []);

  const value = useMemo(() => branding, [branding]);
  return <BrandContext.Provider value={value}>{children}</BrandContext.Provider>;
}
