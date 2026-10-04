'use client';

// Theme3 Providers — full game-provider directory, cream / gold.

import { useMemo } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { ArrowLeft, Play } from 'lucide-react';
import { useGameCatalog } from '@/hooks/useGameCatalog';
import { filterByProvider, playPath, providerEntries, providerHref, PROVIDERS_HREF } from '@/lib/gameRoutes';
import { T3Card } from '../components/ui';

const CATALOG_LIMIT = 2000;

function ProviderCircle({ name, logoUrl, count }) {
  return (
    <Link href={providerHref(name)} title={name} className="group flex flex-col items-center gap-1.5">
      <span className="grid h-20 w-20 shrink-0 place-items-center overflow-hidden rounded-full border border-[#c79a3b]/20 bg-gradient-to-br from-white to-[#faf6ec] p-2 text-center shadow-sm transition group-hover:border-[#c79a3b]">
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
          <span className="line-clamp-2 text-[0.6rem] font-black uppercase leading-tight tracking-wide text-[#1b1726]">
            {name}
          </span>
        )}
      </span>
      <span className="text-[0.6rem] font-bold text-[#9a94a8]">
        {count} {count === 1 ? 'game' : 'games'}
      </span>
    </Link>
  );
}

function GameTile({ game }) {
  return (
    <Link href={playPath(game)} className="group flex flex-col text-left">
      <span className="relative grid aspect-[3/4] place-items-center overflow-hidden rounded-2xl border border-black/[0.06] bg-gradient-to-br from-[#efe9f6] to-[#e2dcf0] shadow-sm">
        {game.thumbnail_url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={game.thumbnail_url}
            alt=""
            className="absolute inset-0 h-full w-full object-cover"
            loading="lazy"
          />
        ) : (
          <Play className="h-7 w-7 text-[#b6aecb]" />
        )}
        <span className="absolute inset-0 transition group-hover:bg-black/25" />
        <span className="relative grid h-12 w-12 scale-90 place-items-center rounded-full bg-gradient-to-br from-[#e9c56b] to-[#b8862f] opacity-0 shadow-lg transition group-hover:scale-100 group-hover:opacity-100">
          <Play className="h-5 w-5 fill-[#241b0e] text-[#241b0e]" />
        </span>
      </span>
      <span className="mt-2 truncate text-sm font-black text-[#1b1726]">{game.name}</span>
      {game.provider_name && (
        <span className="truncate text-xs text-[#9a94a8]">{game.provider_name}</span>
      )}
    </Link>
  );
}

export default function Theme3Providers() {
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
      <div className="mx-auto max-w-[1500px] px-4 py-8">
        <button
          type="button"
          onClick={() => router.push(PROVIDERS_HREF)}
          className="mb-4 inline-flex items-center gap-1.5 text-xs font-black uppercase tracking-wide text-[#c79a3b]"
        >
          <ArrowLeft className="h-3.5 w-3.5" />
          Back to providers
        </button>
        <h1 className="font-display text-2xl font-black text-[#1b1726]">{selected}</h1>
        <div className="mt-6 grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6">
          {providerGames.map((game) => (
            <GameTile key={game.id} game={game} />
          ))}
        </div>
        {!loading && providerGames.length === 0 && (
          <p className="py-8 text-center text-sm text-[#9a94a8]">
            No games available from {selected} right now.
          </p>
        )}
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-[1500px] px-4 py-8">
      <h1 className="font-display text-2xl font-black text-[#1b1726]">Game Providers</h1>
      <T3Card className="mt-6 p-5">
        <div className="flex flex-wrap gap-4">
          {providers.map(({ name, logoUrl, count }) => (
            <ProviderCircle key={name} name={name} logoUrl={logoUrl} count={count} />
          ))}
        </div>
        {!loading && providers.length === 0 && (
          <p className="py-8 text-center text-sm text-[#9a94a8]">No providers available right now.</p>
        )}
      </T3Card>
    </div>
  );
}
