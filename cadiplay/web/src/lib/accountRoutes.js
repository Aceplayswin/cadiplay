// The player's own account pages — Deposit, Profile, Wallet, Bet History,
// Transactions, Promotions, My Bonuses and Change Password.
//
// These are focused, form-heavy tasks rather than browsing, so on phones the
// lobby chrome around them can be hidden. Desktop keeps the full chrome.

export const ACCOUNT_ROUTES = [
  '/deposit',
  '/profile',
  '/wallet',
  '/bet-history',
  '/transactions',
  '/promotions',
  '/bonus',
  '/change-password',
];

export function isAccountRoute(pathname) {
  if (!pathname) return false;
  return ACCOUNT_ROUTES.some(
    (route) => pathname === route || pathname.startsWith(`${route}/`),
  );
}

export const HIDE_ON_MOBILE = 'hidden sm:block';
