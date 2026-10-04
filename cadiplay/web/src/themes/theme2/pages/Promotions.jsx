'use client';

// Theme2 Promotions — offer posters from admin Content → Promotions.

import { Gift } from 'lucide-react';
import { usePromotionPosters } from '@/hooks/usePromotionPosters';
import PromotionPosterCard from '@/components/PromotionPosterCard';
import { T2Card } from '../components/ui';

export default function Theme2Promotions() {
  const { posters, loading } = usePromotionPosters();

  return (
    <div className="mx-auto max-w-[1100px] px-4 py-8">
      <h1 className="font-display text-2xl font-black text-white">Promotions</h1>
      <p className="mt-1 text-sm text-slate-400">
        Current offers and deals. Tap a poster for details.
      </p>

      {loading ? (
        <div className="mt-6 grid gap-4">
          {[0, 1].map((i) => (
            <T2Card key={i} className="aspect-[21/9] animate-pulse" />
          ))}
        </div>
      ) : posters.length === 0 ? (
        <T2Card className="mt-6 flex flex-col items-center gap-2 p-12 text-center">
          <Gift className="h-8 w-8 text-amber-400" />
          <p className="font-display text-lg font-black text-white">No active promotions right now</p>
          <p className="text-sm text-slate-400">Check back soon for new offers.</p>
        </T2Card>
      ) : (
        <div className="mt-6 grid gap-4">
          {posters.map((p) => (
            <PromotionPosterCard
              key={p.id}
              poster={p}
              className="border border-white/5 bg-[#0d1420] shadow-sm transition hover:border-amber-400/30"
            />
          ))}
        </div>
      )}
    </div>
  );
}
