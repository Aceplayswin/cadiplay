'use client';

// Theme3 Games (category listing) — shared games endpoint, cream style.

import { useEffect, useState } from 'react';
import { useParams, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { Play } from 'lucide-react';
import { api } from '@/services/api';
import { categoryFromSlug, playPath } from '@/lib/gameRoutes';

function GameTile({ game }) {
  return (
    <Link href={playPath(game)} className="group flex flex-col text-left">
      <span className="relative grid aspect-[3/4] place-items-center overflow-hidden rounded-2xl border border-black/[0.06] bg-gradient-to-br from-[#efe9f6] to-[#e2dcf0] shadow-sm">
        {game.thumbnail_url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={game.thumbnail_url} alt="" className="absolute inset-0 h-full w-full object-cover" loading="lazy" />
        ) : (
          <Play className="h-7 w-7 text-[#b6aecb]" />
        )}
        <span className="absolute inset-0 transition group-hover:bg-black/25" />
        <span className="relative grid h-12 w-12 scale-90 place-items-center rounded-full bg-gradient-to-br from-[#e9c56b] to-[#b8862f] opacity-0 shadow-lg transition group-hover:scale-100 group-hover:opacity-100">
          <Play className="h-5 w-5 fill-[#241b0e] text-[#241b0e]" />
        </span>
      </span>
      <span className="mt-2 truncate text-sm font-black text-[#1b1726]">{game.name}</span>
      {game.provider_name && <span className="truncate text-xs text-[#9a94a8]">{game.provider_name}</span>}
    </Link>
  );
}

export default function Theme3Games() {
  const params = useParams();
  const searchParams = useSearchParams();
  const category = categoryFromSlug(params.category);
  const q = (searchParams.get('q') ?? '').trim();
  const [games, setGames] = useState([]);

  useEffect(() => {
    let active = true;
    const url = `/api/v1/games?limit=200${
      category && category !== 'all' ? `&category=${category}` : ''
    }${q ? `&search=${encodeURIComponent(q)}` : ''}`;
    api(url)
      .then((data) => active && setGames(Array.isArray(data) ? data : []))
      .catch(() => active && setGames([]));
    return () => {
      active = false;
    };
  }, [category, q]);

  const title =
    q || (params.category === 'all' ? 'All Games' : params.category?.replace(/-/g, ' ')) || 'Games';

  return (
    <div className="mx-auto max-w-[1500px] px-4 py-8">
      <h1 className="font-display text-2xl font-black capitalize text-[#1b1726]">{title}</h1>
      <div className="mt-6 grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6">
        {games.map((game) => <GameTile key={game.id} game={game} />)}
      </div>
      {games.length === 0 && (
        <p className="mt-8 text-center text-[#9a94a8]">
          {q ? `No ${q} tables available right now.` : 'No games found. Start API and seed DB.'}
        </p>
      )}
    </div>
  );
}
