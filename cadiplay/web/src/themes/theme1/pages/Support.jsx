'use client';

// Theme1 Support — shared AI chat endpoint, dark glass look.

import { useState } from 'react';
import Link from 'next/link';
import { Send } from 'lucide-react';
import { api } from '@/services/api';
import { useAuthStore } from '@/store/auth';
import { useBranding } from '@/hooks/useBranding';

export default function Theme1Support() {
  const { token } = useAuthStore();
  const branding = useBranding();
  const [messages, setMessages] = useState([
    {
      role: 'bot',
      text: `Hi! I'm your ${branding.product_name || 'CADIPLAY'} assistant. How can I help?`,
    },
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);

  const send = async (text) => {
    const msg = text || input.trim();
    if (!msg) return;
    setMessages((m) => [...m, { role: 'user', text: msg }]);
    setInput('');
    if (!token) {
      setMessages((m) => [...m, { role: 'bot', text: 'Please login to use support chat.' }]);
      return;
    }
    setLoading(true);
    try {
      const res = await api('/api/v1/ai/chat', {
        method: 'POST',
        body: JSON.stringify({ message: msg }),
      });
      setMessages((m) => [...m, { role: 'bot', text: res.reply }]);
    } catch (e) {
      setMessages((m) => [...m, { role: 'bot', text: e.message }]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="mx-auto flex max-w-lg flex-1 flex-col px-4 py-8">
      <h1 className="text-2xl font-bold">Live Support</h1>
      <div className="card-glass mt-4 flex min-h-[400px] flex-1 flex-col p-4">
        <div className="flex-1 space-y-3 overflow-y-auto">
          {messages.map((m, i) => (
            <div
              key={i}
              className={`max-w-[85%] rounded-xl px-3 py-2 text-sm ${
                m.role === 'user'
                  ? 'ml-auto bg-brand-500 text-surface-900'
                  : 'bg-white/[0.04] text-slate-200'
              }`}
            >
              {m.text}
            </div>
          ))}
        </div>
        <div className="mt-4 flex gap-2">
          <input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && send()}
            placeholder="Type a message..."
            className="w-full rounded-lg border border-white/10 bg-surface-700 px-4 py-3 text-white outline-none focus:border-brand-500/60"
          />
          <button
            type="button"
            disabled={loading}
            onClick={() => send()}
            className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-brand-500 text-surface-900 transition hover:bg-brand-400 disabled:opacity-50"
          >
            <Send className="h-4 w-4" />
          </button>
        </div>
        {!token ? (
          <p className="mt-3 text-center text-sm text-slate-500">
            <Link href="/login" className="font-semibold text-brand-400">
              Login
            </Link>{' '}
            for full support
          </p>
        ) : null}
      </div>
    </main>
  );
}
