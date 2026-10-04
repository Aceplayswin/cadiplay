'use client';

// Shared catalog search used by every theme's chrome. Themes pass class names
// so the box matches their palette; the query, results, and /games/all?q=
// destination stay the same as theme5.

import { useCallback, useEffect, useId, useRef, useState } from 'react';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { Loader2, Play, Search, X } from 'lucide-react';
import { useGameSearch } from '@/hooks/useGameSearch';
import { playPath, NAV_GAME_LINKS } from '@/lib/gameRoutes';

const RESULT_LIMIT = 20;

function viewAllHref(term) {
  return `${NAV_GAME_LINKS.allGames}?q=${encodeURIComponent(term)}`;
}

export function GameSearch({
  className = '',
  inputClassName,
  panelClassName,
  rowActiveClassName,
  accentClassName = '',
}) {
  const pathname = usePathname();
  const router = useRouter();
  const listId = useId();
  const rootRef = useRef(null);
  const inputRef = useRef(null);
  const [query, setQuery] = useState('');
  const [open, setOpen] = useState(false);
  const term = query.trim();
  const { results, loading } = useGameSearch(term, { limit: RESULT_LIMIT, debounceMs: 250 });

  const close = useCallback(() => {
    setOpen(false);
    inputRef.current?.blur();
  }, []);

  useEffect(() => {
    setOpen(false);
  }, [pathname]);

  useEffect(() => {
    const onKeyDown = (e) => {
      const el = e.target;
      const typing =
        el instanceof HTMLElement &&
        (el.isContentEditable || /^(INPUT|TEXTAREA|SELECT)$/.test(el.tagName));
      const slash = e.key === '/' && !typing && !e.ctrlKey && !e.metaKey && !e.altKey;
      const cmdK = (e.ctrlKey || e.metaKey) && e.key?.toLowerCase() === 'k';
      const input = inputRef.current;
      if ((!slash && !cmdK) || !input || input.offsetParent === null) return;
      e.preventDefault();
      input.focus();
      input.select();
    };
    document.addEventListener('keydown', onKeyDown);
    return () => document.removeEventListener('keydown', onKeyDown);
  }, []);

  const submit = () => {
    if (!term) return;
    setQuery('');
    close();
    router.push(viewAllHref(term));
  };

  return (
    <div
      ref={rootRef}
      role="search"
      className={`relative ${className}`}
      onBlur={(e) => {
        if (!rootRef.current?.contains(e.relatedTarget)) setOpen(false);
      }}
    >
      <form
        onSubmit={(e) => {
          e.preventDefault();
          submit();
        }}
      >
        {loading ? (
          <Loader2 className={`pointer-events-none absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 animate-spin ${accentClassName}`} />
        ) : (
          <Search className="pointer-events-none absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 opacity-50" />
        )}
        <input
          ref={inputRef}
          type="text"
          aria-label="Search games"
          aria-expanded={open}
          aria-controls={listId}
          autoComplete="off"
          placeholder="Search games or providers"
          value={query}
          onChange={(e) => {
            setQuery(e.target.value);
            setOpen(true);
          }}
          onFocus={() => setOpen(true)}
          onKeyDown={(e) => {
            if (e.key === 'Escape') {
              e.preventDefault();
              close();
            }
          }}
          className={inputClassName}
        />
        {query ? (
          <button
            type="button"
            aria-label="Clear search"
            onMouseDown={(e) => e.preventDefault()}
            onClick={() => {
              setQuery('');
              inputRef.current?.focus();
            }}
            className="absolute right-2 top-1/2 grid h-6 w-6 -translate-y-1/2 place-items-center opacity-60 hover:opacity-100"
          >
            <X className="h-4 w-4" />
          </button>
        ) : null}
      </form>

      {open && term && (
        <div
          onMouseDown={(e) => e.preventDefault()}
          className={panelClassName}
        >
          <ul id={listId} role="listbox" aria-label="Search results">
            {loading && results.length === 0 ? (
              <li className="px-4 py-6 text-center text-sm opacity-60">Searching…</li>
            ) : results.length === 0 ? (
              <li className="px-4 py-6 text-center text-sm opacity-60">No games match “{term}”</li>
            ) : (
              results.map((game) => (
                <li key={game.id} role="option">
                  <Link
                    href={playPath(game)}
                    onClick={() => {
                      setQuery('');
                      close();
                    }}
                    className={`flex items-center gap-3 px-3 py-2 ${rowActiveClassName}`}
                  >
                    <span className="relative grid h-10 w-10 shrink-0 place-items-center overflow-hidden rounded-lg bg-black/20">
                      {game.thumbnail_url ? (
                        // eslint-disable-next-line @next/next/no-img-element
                        <img
                          src={game.thumbnail_url}
                          alt=""
                          className="absolute inset-0 h-full w-full object-cover"
                          loading="lazy"
                        />
                      ) : (
                        <Play className="h-4 w-4 opacity-40" />
                      )}
                    </span>
                    <span className="min-w-0 flex-1">
                      <span className="block truncate text-sm font-bold">{game.name}</span>
                      {game.provider_name && (
                        <span className="block truncate text-xs opacity-60">{game.provider_name}</span>
                      )}
                    </span>
                  </Link>
                </li>
              ))
            )}
          </ul>
          {results.length > 0 && (
            <Link
              href={viewAllHref(term)}
              onClick={() => {
                setQuery('');
                close();
              }}
              className={`block border-t px-3 py-3 text-center text-xs font-bold uppercase tracking-wide ${accentClassName}`}
            >
              View all results for “{term}”
            </Link>
          )}
        </div>
      )}
    </div>
  );
}
