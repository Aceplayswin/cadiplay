'use client';

// Theme4 Promotions — offer posters, teal exchange.

import { Gift } from 'lucide-react';
import { usePromotionPosters } from '@/hooks/usePromotionPosters';
import PromotionPosterCard from '@/components/PromotionPosterCard';
import { T4Card, T4FormPage } from '../components/ui';

export default function Theme4Promotions() {
  const { posters, loading } = usePromotionPosters();

  return (
    <T4FormPage
      title="Promotions"
      subtitle="Current offers and deals. Tap a poster for details."
      maxWidth="max-w-[1100px]"
    >
      {loading ? (
        <div className="mt-4 grid gap-4">
          {[0, 1].map((i) => (
            <T4Card key={i} className="aspect-[21/9] animate-pulse" />
          ))}
        </div>
      ) : posters.length === 0 ? (
        <T4Card className="mt-4 flex flex-col items-center gap-2 p-12 text-center">
          <Gift className="h-8 w-8 text-[#0e7480]" />
          <p className="font-display text-lg font-black text-[#13272b]">
            No active promotions right now
          </p>
          <p className="text-sm text-[#5d7378]">Check back soon for new offers.</p>
        </T4Card>
      ) : (
        <div className="mt-4 grid gap-4">
          {posters.map((p) => (
            <PromotionPosterCard
              key={p.id}
              poster={p}
              className="border border-black/[0.07] bg-white shadow-sm transition hover:border-[#0e7480]/40"
            />
          ))}
        </div>
      )}
    </T4FormPage>
  );
}
