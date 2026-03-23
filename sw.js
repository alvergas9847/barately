const CACHE = 'barately-v1';
const ASSETS = [
  '/',
  '/index.html',
  '/dashboard.html',
  '/ventas.html',
  '/resumen_venta.html',
  '/inventario.html',
  '/clientes.html',
  '/proveedores.html',
  '/finanzas.html',
  '/usuarios.html',
  '/ia.html',
  '/nav.js',
  'https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Mono:wght@400;500&family=DM+Sans:wght@300;400;500&display=swap',
  'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2',
];

// Instalar y cachear assets
self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting())
  );
});

// Activar y limpiar caches viejos
self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

// Fetch: network first para Supabase, cache first para assets
self.addEventListener('fetch', e => {
  const url = e.request.url;

  // Supabase siempre desde red
  if (url.includes('supabase.co') || url.includes('anthropic.com')) {
    e.respondWith(fetch(e.request).catch(() => new Response('{}', { headers: { 'Content-Type': 'application/json' }})));
    return;
  }

  // Assets: cache first, luego red
  e.respondWith(
    caches.match(e.request).then(cached => {
      if (cached) return cached;
      return fetch(e.request).then(res => {
        if (res && res.status === 200 && e.request.method === 'GET') {
          const clone = res.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
        }
        return res;
      }).catch(() => caches.match('/index.html'));
    })
  );
});
