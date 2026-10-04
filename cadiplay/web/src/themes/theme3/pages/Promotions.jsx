'use client';

// Theme3 Promotions — offer posters, cream / gold.

import { Gift } from 'lucide-react';
import { usePromotionPosters } from '@/hooks/usePromotionPosters';
import PromotionPosterCard from '@/components/PromotionPosterCard';
import { T3Card } from '../components/ui';

export default function Theme3Promotions() {
  const { posters, loading } = usePromotionPosters();

  return (
    <div className="mx-auto max-w-[1100px] px-4 py-8">
      <h1 className="font-display text-2xl font-black text-[#1b1726]">Promotions</h1>
      <p className="mt-1 text-sm text-[#6b6579]">
        Current offers and deals. Tap a poster for details.
      </p>

      {loading ? (
        <div className="mt-6 grid gap-4">
          {[0, 1].map((i) => (
            <T3Card key={i} className="aspect-[21/9] animate-pulse" />
          ))}
        </div>
      ) : posters.length === 0 ? (
        <T3Card className="mt-6 flex flex-col items-center gap-2 p-12 text-center">
          <Gift className="h-8 w-8 text-[#c79a3b]" />
          <p className="font-display text-lg font-black text-[#1b1726]">
            No active promotions right now
          </p>
          <p className="text-sm text-[#6b6579]">Check back soon for new offers.</p>
        </T3Card>
      ) : (
        <div className="mt-6 grid gap-4">
          {posters.map((p) => (
            <PromotionPosterCard
              key={p.id}
              poster={p}
              className="border border-black/[0.06] bg-white shadow-sm transition hover:border-[#c79a3b]/40"
            />
          ))}
        </div>
      )}
    </div>
  );
}
