'use client';

// Theme4 Providers — full game-provider directory, teal exchange.

import { useMemo } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { ArrowLeft, Play } from 'lucide-react';
import { useGameCatalog } from '@/hooks/useGameCatalog';
import { filterByProvider, playPath, providerEntries, providerHref, PROVIDERS_HREF } from '@/lib/gameRoutes';
import { T4SectionBar } from '../components/ui';

const CATALOG_LIMIT = 2000;

function ProviderCircle({ name, logoUrl, count }) {
  return (
    <Link href={providerHref(name)} title={name} className="group flex flex-col items-center gap-1.5">
      <span className="grid h-20 w-20 shrink-0 place-items-center overflow-hidden rounded-full border border-[#0e7480]/20 bg-[#eef6f7] p-2 text-center shadow-sm transition group-hover:border-[#0e7480]">
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
          <span className="line-clamp-2 text-[0.6rem] font-black uppercase leading-tight tracking-wide text-[#13272b]">
            {name}
          </span>
        )}
      </span>
      <span className="text-[0.6rem] font-bold text-[#8aa0a4]">
        {count} {count === 1 ? 'game' : 'games'}
      </span>
    </Link>
  );
}

function GameTile({ game }) {
  return (
    <Link href={playPath(game)} className="group flex flex-col text-left">
      <span className="relative grid aspect-square place-items-center overflow-hidden rounded bg-gradient-to-br from-[#0a5560] to-[#101c1e] shadow-sm">
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
        <span className="absolute inset-0 transition group-hover:bg-black/30" />
        <span className="relative grid h-11 w-11 scale-90 place-items-center rounded-full bg-gradient-to-b from-[#17a2b0] to-[#0e7480] opacity-0 shadow-lg transition group-hover:scale-100 group-hover:opacity-100">
          <Play className="h-5 w-5 fill-white text-white" />
        </span>
      </span>
      <span className="mt-1.5 truncate text-xs font-bold text-[#13272b]">{game.name}</span>
      {game.provider_name && (
        <span className="truncate text-[0.65rem] text-[#8aa0a4]">{game.provider_name}</span>
      )}
    </Link>
  );
}

export default function Theme4Providers() {
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
      <div className="mx-auto max-w-[1200px] px-2 py-4 sm:px-3">
        <T4SectionBar>{selected}</T4SectionBar>
        <div className="rounded-b border border-t-0 border-black/[0.07] bg-white p-3">
          <button
            type="button"
            onClick={() => router.push(PROVIDERS_HREF)}
            className="mb-3 inline-flex items-center gap-1.5 text-xs font-black uppercase tracking-wide text-[#0e7480]"
          >
            <ArrowLeft className="h-3.5 w-3.5" />
            Back to providers
          </button>
          <div className="grid grid-cols-3 gap-3 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8">
            {providerGames.map((game) => (
              <GameTile key={game.id} game={game} />
            ))}
          </div>
          {!loading && providerGames.length === 0 && (
            <p className="py-8 text-center text-sm text-[#8aa0a4]">
              No games available from {selected} right now.
            </p>
          )}
        </div>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-[1200px] px-2 py-4 sm:px-3">
      <T4SectionBar>Game Providers</T4SectionBar>
      <div className="rounded-b border border-t-0 border-black/[0.07] bg-white p-4">
        <div className="flex flex-wrap gap-4">
          {providers.map(({ name, logoUrl, count }) => (
            <ProviderCircle key={name} name={name} logoUrl={logoUrl} count={count} />
          ))}
        </div>
        {!loading && providers.length === 0 && (
          <p className="py-8 text-center text-sm text-[#8aa0a4]">No providers available right now.</p>
        )}
      </div>
    </div>
  );
}
