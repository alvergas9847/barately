/**
 * BARATELY — nav.js
 * Navegación compartida, control de roles y sidebar dinámico.
 * Incluir en todas las páginas después del SDK de Supabase.
 *
 * Uso:
 *   <script src="nav.js"></script>
 *   <script> Nav.init('dashboard'); </script>
 */

const Nav = (() => {

  // ── Configuración de Supabase ─────────────────────────────
  const SUPABASE_URL = 'https://mcbbdzldvlmcpbhzlkpn.supabase.co';
  const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1jYmJkemxkdmxtY3BiaHpsa3BuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQxMTQ4MzAsImV4cCI6MjA4OTY5MDgzMH0.TmccIp3NdW_YnvR5whRsO3zLIyrzO-RZTPjN5OGqo3Y';

  // ── Definición de menú por rol ────────────────────────────
  // Cada item: { id, label, icon, href, roles[] }
  // roles: qué roles VEN este item (vacío = todos con acceso web)
   const MENU = [
    {
      seccion: 'Principal',
      items: [
        { id: 'dashboard',   label: 'Dashboard',   icon: '▣', href: 'dashboard.html',   roles: ['admin','encargado','contador'] },
      ]
    },
    {
      seccion: 'Operaciones',
      items: [
        { id: 'ventas',        label: 'Nueva venta',    icon: '＋', href: 'ventas.html',        roles: ['admin','encargado'] },
        { id: 'resumen_venta', label: 'Resumen ventas', icon: '◎', href: 'resumen_venta.html', roles: ['admin','encargado'] },
        { id: 'clientes',      label: 'Clientes',       icon: '◯', href: 'clientes.html',      roles: ['admin','encargado'] },
        { id: 'inventario',    label: 'Inventario',     icon: '◻', href: 'inventario.html',    roles: ['admin','encargado'] },
        { id: 'proveedores',   label: 'Proveedores',    icon: '⬡', href: 'proveedores.html',   roles: ['admin','encargado','contador'] },
      ]
    },
    {
      seccion: 'Administración',
      items: [
        { id: 'finanzas',  label: 'Finanzas',    icon: '◈', href: 'finanzas.html',  roles: ['admin','contador'] },
        { id: 'usuarios',  label: 'Usuarios',    icon: '◉', href: 'usuarios.html',  roles: ['admin'] },
        { id: 'ia',        label: 'IA & Alertas', icon: '✦', href: 'ia.html',        roles: ['admin','encargado'], badge: () => Nav._alertas },
      ]
    },
    {
      seccion: 'Ayuda',
      items: [
        { id: 'manual', label: 'Manual de uso', icon: '?', href: 'manual.html', roles: ['admin','encargado','contador'] },
      ]
    },
  ];
  // ── Permisos por página ───────────────────────────────────
  // Qué roles pueden acceder a cada página
const PERMISOS = {
    'dashboard':     ['admin','encargado','contador'],
    'ventas':        ['admin','encargado'],
    'resumen_venta': ['admin','encargado'],
    'clientes':      ['admin','encargado'],
    'inventario':    ['admin','encargado'],
    'proveedores':   ['admin','encargado','contador'],
    'finanzas':      ['admin','contador'],
    'usuarios':      ['admin'],
    'ia':            ['admin','encargado'],
    'manual':        ['admin','encargado','contador'],
  };

  // ── Capacidades por rol ───────────────────────────────────
  const CAPS = {
    admin: {
      puedeCrear:    true,
      puedeEditar:   true,
      puedeOcultar:  true,
      verCostos:     true,
      verFinanzas:   true,
      verTodo:       true,
    },
    encargado: {
      puedeCrear:    false,
      puedeEditar:   true,
      puedeOcultar:  false,
      verCostos:     false,
      verFinanzas:   false,
      verTodo:       false,
    },
    contador: {
      puedeCrear:    false,
      puedeEditar:   false,
      puedeOcultar:  false,
      verCostos:     true,
      verFinanzas:   true,
      verTodo:       false,
    },
    vendedor: {
      puedeCrear:    false,
      puedeEditar:   false,
      puedeOcultar:  false,
      verCostos:     false,
      verFinanzas:   false,
      verTodo:       false,
    },
    practicante: {
      puedeCrear:    false,
      puedeEditar:   false,
      puedeOcultar:  false,
      verCostos:     false,
      verFinanzas:   false,
      verTodo:       false,
    },
  };

  // ── Estado interno ────────────────────────────────────────
  let _user     = null;
  let _sb       = null;
  let _alertas  = 0;
  let _paginaActual = '';

  // ── Inicialización ────────────────────────────────────────
  async function init(paginaId) {
    _paginaActual = paginaId;

    // Verificar sesión
    _user = JSON.parse(localStorage.getItem('barately_user') || 'null');
    if (!_user) {
      window.location.href = 'index.html';
      return;
    }

    // Verificar permiso de página
    const permisosP = PERMISOS[paginaId] || [];
    if (permisosP.length && !permisosP.includes(_user.rol)) {
      window.location.href = 'dashboard.html';
      return;
    }

    // Inicializar Supabase
    const { createClient } = supabase;
    _sb = createClient(SUPABASE_URL, SUPABASE_KEY);

    // Cargar alertas en segundo plano
    cargarAlertas();

    // Renderizar sidebar
    renderSidebar();

    // Fecha en topbar
    const fechaEl = document.getElementById('navFecha');
    if (fechaEl) {
      const DIAS  = ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'];
      const MESES = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
      const now   = new Date();
      fechaEl.textContent = `${DIAS[now.getDay()]} ${now.getDate()} ${MESES[now.getMonth()]} ${now.getFullYear()}`;
    }

    // Usuario en sidebar
    const elNombre = document.getElementById('navNombre');
    const elRol    = document.getElementById('navRol');
    const elAvatar = document.getElementById('navAvatar');
    if (elNombre) elNombre.textContent = _user.nombre || '—';
    if (elRol)    elRol.textContent    = _user.rol    || '—';
    if (elAvatar) elAvatar.textContent = (_user.nombre || 'U')[0].toUpperCase();
  }

  // ── Renderizar sidebar ────────────────────────────────────
  function renderSidebar() {
    const navEl = document.getElementById('navMenu');
    if (!navEl) return;

    let html = '';
    MENU.forEach(sec => {
      // Filtrar items visibles para este rol
      const visibles = sec.items.filter(item =>
        !item.roles.length || item.roles.includes(_user.rol)
      );
      if (!visibles.length) return;

      html += `<div class="nav-sec">${sec.seccion}</div>`;
      visibles.forEach(item => {
        const activo = item.id === _paginaActual ? 'active' : '';
        const badge  = item.badge ? item.badge() : 0;
        const badgeHtml = badge > 0
          ? `<span class="nav-badge">${badge}</span>`
          : '';
        html += `
          <a class="nav-item ${activo}" href="${item.href}">
            <span class="nav-icon">${item.icon}</span>
            ${item.label}
            ${badgeHtml}
          </a>`;
      });
    });

    navEl.innerHTML = html;
  }

  // ── Cargar alertas ────────────────────────────────────────
  async function cargarAlertas() {
    if (!_sb) return;
    try {
      const res = await _sb
        .from('alertas_ia')
        .select('id', { count: 'exact' })
        .eq('leida', false);
      _alertas = res.count || 0;
      // Actualizar badge en sidebar
      const badgeEl = document.querySelector('.nav-item[href="ia.html"] .nav-badge');
      if (badgeEl) badgeEl.textContent = _alertas;
      else if (_alertas > 0) renderSidebar();
    } catch(e) {}
  }

  // ── Helpers públicos ──────────────────────────────────────
  function getUser()   { return _user; }
  function getSb()     { return _sb; }
  function getCaps()   { return CAPS[_user?.rol] || CAPS.vendedor; }
  function getRol()    { return _user?.rol || ''; }

  function puede(cap) {
    return !!getCaps()[cap];
  }

  function logout() {
    localStorage.removeItem('barately_user');
    window.location.href = 'index.html';
  }

  function toggleSidebar() {
    document.getElementById('navSidebar')?.classList.toggle('open');
    document.getElementById('navOverlay')?.classList.toggle('open');
  }

  function closeSidebar() {
    document.getElementById('navSidebar')?.classList.remove('open');
    document.getElementById('navOverlay')?.classList.remove('open');
  }

  // ── Notificación toast ────────────────────────────────────
  function toast(msg, tipo = 'ok') {
    let el = document.getElementById('navToast');
    if (!el) {
      el = document.createElement('div');
      el.id = 'navToast';
      document.body.appendChild(el);
    }
    el.textContent = msg;
    el.className = `nav-toast ${tipo} show`;
    clearTimeout(el._t);
    el._t = setTimeout(() => el.classList.remove('show'), 3000);
  }

  // ── HTML del sidebar (incluir en cada página) ─────────────
  function sidebarHTML() {
    return `
      <div class="nav-overlay" id="navOverlay" onclick="Nav.closeSidebar()"></div>
      <aside class="nav-sidebar" id="navSidebar">
        <div class="nav-logo">
          <div class="nav-logo-name">BARATELY</div>
          <div class="nav-logo-sub">Panel Admin</div>
        </div>
        <nav id="navMenu"></nav>
        <div class="nav-footer">
          <div class="nav-user">
            <div class="nav-avatar" id="navAvatar">G</div>
            <div>
              <div class="nav-username" id="navNombre">—</div>
              <div class="nav-userrole" id="navRol">—</div>
            </div>
          </div>
        </div>
      </aside>`;
  }

  // ── CSS del sidebar (incluir una vez en cada página) ──────
  function sidebarCSS() {
    return `
      <style id="nav-styles">
      .nav-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:90;}
      .nav-overlay.open{display:block;}
      .nav-sidebar{
        width:220px;flex-shrink:0;
        background:#111118;
        border-right:1px solid rgba(255,255,255,0.06);
        display:flex;flex-direction:column;
        position:fixed;top:0;left:0;bottom:0;
        z-index:100;transition:transform .3s;
      }
      .nav-sidebar.open{transform:translateX(0)!important;}
      .nav-logo{padding:22px 20px;border-bottom:1px solid rgba(255,255,255,0.06);}
      .nav-logo-name{
        font-family:'Syne',sans-serif;font-weight:800;font-size:20px;
        letter-spacing:.1em;
        background:linear-gradient(135deg,#fff 30%,#6c5ce7 100%);
        -webkit-background-clip:text;-webkit-text-fill-color:transparent;
      }
      .nav-logo-sub{font-size:9px;color:#6b6b82;letter-spacing:.16em;text-transform:uppercase;margin-top:3px;font-family:'DM Mono',monospace;}
      nav{flex:1;padding:10px 0;overflow-y:auto;}
      .nav-sec{font-size:9px;font-weight:600;letter-spacing:.14em;text-transform:uppercase;color:#6b6b82;padding:12px 20px 4px;}
      .nav-item{
        display:flex;align-items:center;gap:10px;
        padding:9px 20px;font-size:13px;color:#6b6b82;
        text-decoration:none;border-left:2px solid transparent;
        transition:all .15s;user-select:none;font-family:'DM Sans',sans-serif;
      }
      .nav-item:hover{color:#ededf5;background:rgba(255,255,255,0.03);}
      .nav-item.active{color:#6c5ce7;border-left-color:#6c5ce7;background:rgba(108,92,231,0.08);}
      .nav-icon{width:16px;text-align:center;font-size:14px;flex-shrink:0;}
      .nav-badge{
        margin-left:auto;background:#e84343;color:#fff;
        font-size:10px;font-weight:700;border-radius:99px;
        padding:1px 6px;min-width:18px;text-align:center;
      }
      .nav-footer{padding:14px 20px;border-top:1px solid rgba(255,255,255,0.06);}
      .nav-user{display:flex;align-items:center;gap:10px;}
      .nav-avatar{
        width:30px;height:30px;border-radius:50%;
        background:linear-gradient(135deg,#6c5ce7,#a855f7);
        display:flex;align-items:center;justify-content:center;
        font-size:11px;font-weight:700;color:#fff;flex-shrink:0;
        font-family:'Syne',sans-serif;
      }
      .nav-username{font-size:12px;font-weight:500;color:#ededf5;}
      .nav-userrole{font-size:10px;color:#6b6b82;text-transform:uppercase;letter-spacing:.06em;}
      .nav-toast{
        position:fixed;bottom:24px;right:24px;z-index:300;
        background:#111118;border:1px solid rgba(255,255,255,0.1);
        border-radius:10px;padding:12px 18px;font-size:13px;
        color:#ededf5;font-family:'DM Sans',sans-serif;
        box-shadow:0 8px 32px rgba(0,0,0,.4);
        transform:translateY(80px);opacity:0;
        transition:transform .3s,opacity .3s;max-width:320px;
      }
      .nav-toast.show{transform:translateY(0);opacity:1;}
      .nav-toast.ok{border-left:3px solid #43c59e;}
      .nav-toast.err{border-left:3px solid #e84343;}
      .nav-toast.warn{border-left:3px solid #f0a500;}
      @media(max-width:900px){
        .nav-sidebar{transform:translateX(-100%);}
        .nav-main{margin-left:0!important;}
        .nav-hamburger{display:block!important;}
      }
      </style>`;
  }

  // ── Exportar ──────────────────────────────────────────────
  return {
    init, getUser, getSb, getCaps, getRol, puede,
    logout, toggleSidebar, closeSidebar, toast,
    sidebarHTML, sidebarCSS,
    get alertas(){ return _alertas; }
  };

})();
