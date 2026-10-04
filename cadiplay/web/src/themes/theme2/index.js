// Theme 2 manifest — dark sidebar lobby.
//
// Self-contained: shell + pages + any theme-scoped CSS all live under this
// folder, so a build that ships only this theme works unchanged. See
// ../registry.js for how themes are discovered and ../theme1/index.js for the
// annotated reference manifest.

import Shell from './shell/ThemeShell';
import Home from './pages/Home';
import Login from './pages/Login';
import Register from './pages/Register';
import Deposit from './pages/Deposit';
import Withdraw from './pages/Withdraw';
import Wallet from './pages/Wallet';
import Profile from './pages/Profile';
import Onboarding from './pages/Onboarding';
import Support from './pages/Support';
import Games from './pages/Games';
import Play from './pages/Play';
import Providers from './pages/Providers';
import Transactions from './pages/Transactions';
import BetHistory from './pages/BetHistory';
import Bonus from './pages/Bonus';
import Promotions from './pages/Promotions';
import AppDownload from './pages/AppDownload';

export default {
  key: 'theme2',
  pages: {
    home: Home,
    login: Login,
    register: Register,
    deposit: Deposit,
    withdraw: Withdraw,
    wallet: Wallet,
    profile: Profile,
    onboarding: Onboarding,
    support: Support,
    games: Games,
    play: Play,
    providers: Providers,
    transactions: Transactions,
    betHistory: BetHistory,
    bonus: Bonus,
    promotions: Promotions,
    appDownload: AppDownload,
  },
  Shell,
};
