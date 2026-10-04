'use client';

// Theme1 Providers — full game-provider directory. Two states:
//   • no ?provider=  → every provider the catalog carries
//   • ?provider=Name → that provider's games
// Names come from the shared catalog via providerEntries.

import { useMemo } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { ArrowLeft } from 'lucide-react';
import { useGameCatalog } from '@/hooks/useGameCatalog';
import { GameCard } from '@/components/GameCard';
import { filterByProvider, providerEntries, providerHref, PROVIDERS_HREF } from '@/lib/gameRoutes';

const CATALOG_LIMIT = 2000;

function ProviderCircle({ name, logoUrl, count }) {
  return (
    <Link href={providerHref(name)} title={name} className="group flex flex-col items-center gap-1.5">
      <span className="card-glass grid h-20 w-20 shrink-0 place-items-center overflow-hidden rounded-full p-2 text-center transition group-hover:border-brand-500/40">
        {logoUrl ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={logoUrl}
            alt={name}
            loading="lazy"
            className="h-full w-full object-contain"
            onError={(e) => {
              e.currentTarget.style.display = 'none';
            }}
          />
        ) : (
          <span className="line-clamp-2 text-[0.6rem] font-bold uppercase leading-tight tracking-wide text-white">
            {name}
          </span>
        )}
      </span>
      <span className="text-[0.6rem] font-semibold text-slate-500">
        {count} {count === 1 ? 'game' : 'games'}
      </span>
    </Link>
  );
}

export default function Theme1Providers() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const selected = (searchParams.get('provider') ?? '').trim();
  const { games, loading } = useGameCatalog({ limit: CATALOG_LIMIT });

  const providers = useMemo(() => {
    const counts = new Map();
    games.forEach((g) => {
      if (g.provider_name) counts.set(g.provider_name, (counts.get(g.provider_name) ?? 0) + 1);
    });
    return providerEntries(games).map((p) => ({ ...p, count: counts.get(p.name) ?? 0 }));
  }, [games]);

  const providerGames = useMemo(
    () => (selected ? filterByProvider(games, selected) : []),
    [games, selected],
  );

  if (selected) {
    return (
      <main className="mx-auto max-w-7xl flex-1 px-4 py-8">
        <button
          type="button"
          onClick={() => router.push(PROVIDERS_HREF)}
          className="mb-4 inline-flex items-center gap-1.5 text-xs font-bold uppercase tracking-wide text-brand-400"
        >
          <ArrowLeft className="h-3.5 w-3.5" />
          Back to providers
        </button>
        <h1 className="text-2xl font-bold">{selected}</h1>
        <div className="mt-6 grid grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-4">
          {providerGames.map((game) => (
            <GameCard key={game.id} game={game} />
          ))}
        </div>
        {!loading && providerGames.length === 0 && (
          <p className="py-8 text-center text-sm text-slate-500">
            No games available from {selected} right now.
          </p>
        )}
      </main>
    );
  }

  return (
    <main className="mx-auto max-w-7xl flex-1 px-4 py-8">
      <h1 className="text-2xl font-bold">Game Providers</h1>
      <p className="mt-1 text-sm text-slate-400">Every studio in the catalog.</p>
      <div className="card-glass mt-6 p-5">
        <div className="flex flex-wrap gap-4">
          {providers.map(({ name, logoUrl, count }) => (
            <ProviderCircle key={name} name={name} logoUrl={logoUrl} count={count} />
          ))}
        </div>
        {!loading && providers.length === 0 && (
          <p className="py-8 text-center text-sm text-slate-500">
            No providers available right now.
          </p>
        )}
      </div>
    </main>
  );
}
