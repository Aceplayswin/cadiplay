'use client';

// Theme2 Providers — full game-provider directory, dark navy / amber.

import { useMemo } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { ArrowLeft, Play } from 'lucide-react';
import { useGameCatalog } from '@/hooks/useGameCatalog';
import { filterByProvider, playPath, providerEntries, providerHref, PROVIDERS_HREF } from '@/lib/gameRoutes';
import { T2Card } from '../components/ui';

const CATALOG_LIMIT = 2000;

function ProviderCircle({ name, logoUrl, count }) {
  return (
    <Link href={providerHref(name)} title={name} className="group flex flex-col items-center gap-1.5">
      <span className="grid h-20 w-20 shrink-0 place-items-center overflow-hidden rounded-full border border-white/10 bg-[#070d16] p-2 text-center transition group-hover:border-amber-400/60">
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
          <span className="line-clamp-2 text-[0.6rem] font-black uppercase leading-tight tracking-wide text-white">
            {name}
          </span>
        )}
      </span>
      <span className="text-[0.6rem] font-bold text-slate-500">
        {count} {count === 1 ? 'game' : 'games'}
      </span>
    </Link>
  );
}

function GameTile({ game }) {
  return (
    <Link href={playPath(game)} className="group flex flex-col text-left">
      <span className="relative grid aspect-[3/4] place-items-center overflow-hidden rounded-xl border border-white/5 bg-gradient-to-br from-amber-500/20 via-[#0d1420] to-[#070d16]">
        {game.thumbnail_url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={game.thumbnail_url}
            alt=""
            className="absolute inset-0 h-full w-full object-cover"
            loading="lazy"
          />
        ) : (
          <Play className="h-7 w-7 text-white/30" />
        )}
        <span className="absolute inset-0 transition group-hover:bg-black/40" />
        <span className="relative grid h-12 w-12 scale-90 place-items-center rounded-full bg-gradient-to-br from-amber-400 to-amber-600 opacity-0 transition group-hover:scale-100 group-hover:opacity-100">
          <Play className="h-5 w-5 fill-black text-black" />
        </span>
      </span>
      <span className="mt-2 truncate text-sm font-bold text-white">{game.name}</span>
      {game.provider_name && (
        <span className="truncate text-xs text-slate-500">{game.provider_name}</span>
      )}
    </Link>
  );
}

export default function Theme2Providers() {
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
      <div className="mx-auto max-w-[1400px] px-4 py-8">
        <button
          type="button"
          onClick={() => router.push(PROVIDERS_HREF)}
          className="mb-4 inline-flex items-center gap-1.5 text-xs font-black uppercase tracking-wide text-amber-400"
        >
          <ArrowLeft className="h-3.5 w-3.5" />
          Back to providers
        </button>
        <h1 className="font-display text-2xl font-black text-white">{selected}</h1>
        <div className="mt-6 grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6">
          {providerGames.map((game) => (
            <GameTile key={game.id} game={game} />
          ))}
        </div>
        {!loading && providerGames.length === 0 && (
          <p className="py-8 text-center text-sm text-slate-500">
            No games available from {selected} right now.
          </p>
        )}
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-[1400px] px-4 py-8">
      <h1 className="font-display text-2xl font-black text-white">Game Providers</h1>
      <T2Card className="mt-6 p-5">
        <div className="flex flex-wrap gap-4">
          {providers.map(({ name, logoUrl, count }) => (
            <ProviderCircle key={name} name={name} logoUrl={logoUrl} count={count} />
          ))}
        </div>
        {!loading && providers.length === 0 && (
          <p className="py-8 text-center text-sm text-slate-500">No providers available right now.</p>
        )}
      </T2Card>
    </div>
  );
}
