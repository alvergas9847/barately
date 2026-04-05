-- ================================================================
-- MIGRACIÓN COMPLETA — Barately
-- Ejecutar en Supabase > SQL Editor
-- ================================================================
-- PARTE 1: Nuevas columnas y tablas
-- PARTE 2: Políticas RLS para rol anon (login desde móvil/cualquier dispositivo)
-- ================================================================

-- ────────────────────────────────────────────────────────────────
-- PARTE 1 — Imagen de producto + Lotes de inventario
-- ────────────────────────────────────────────────────────────────

-- 1a. Columna imagen_url en productos
ALTER TABLE productos ADD COLUMN IF NOT EXISTS imagen_url TEXT;

-- 1b. Tabla lotes
CREATE TABLE IF NOT EXISTS lotes (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  numero_lote   TEXT NOT NULL UNIQUE,
  fecha_ingreso DATE NOT NULL DEFAULT CURRENT_DATE,
  proveedor_id  UUID REFERENCES proveedores(id) ON DELETE SET NULL,
  notas         TEXT,
  estado        TEXT NOT NULL DEFAULT 'activo' CHECK (estado IN ('activo','cerrado','anulado')),
  usuario_id    UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  creado_en     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 1c. FK lote_id en movimientos_inventario
ALTER TABLE movimientos_inventario ADD COLUMN IF NOT EXISTS lote_id UUID REFERENCES lotes(id) ON DELETE SET NULL;

-- Índices
CREATE INDEX IF NOT EXISTS idx_lotes_estado    ON lotes(estado);
CREATE INDEX IF NOT EXISTS idx_lotes_proveedor ON lotes(proveedor_id);
CREATE INDEX IF NOT EXISTS idx_movinv_lote     ON movimientos_inventario(lote_id);

-- ────────────────────────────────────────────────────────────────
-- PARTE 2 — Políticas RLS para rol ANON
-- El sistema usa autenticación propia (PIN + localStorage),
-- no Supabase Auth. Todas las llamadas llegan con la clave anon.
-- Se otorga acceso completo al rol anon en todas las tablas.
-- ────────────────────────────────────────────────────────────────

-- ── usuarios ──────────────────────────────────────────────────
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_select_usuarios"  ON usuarios;
DROP POLICY IF EXISTS "anon_update_usuarios"  ON usuarios;
CREATE POLICY "anon_select_usuarios" ON usuarios FOR SELECT TO anon USING (true);
CREATE POLICY "anon_update_usuarios" ON usuarios FOR UPDATE TO anon USING (true);

-- ── roles ─────────────────────────────────────────────────────
ALTER TABLE roles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_select_roles" ON roles;
CREATE POLICY "anon_select_roles" ON roles FOR SELECT TO anon USING (true);

-- ── productos ─────────────────────────────────────────────────
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_productos" ON productos;
CREATE POLICY "anon_all_productos" ON productos FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── variantes ─────────────────────────────────────────────────
ALTER TABLE variantes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_variantes" ON variantes;
CREATE POLICY "anon_all_variantes" ON variantes FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── tallas ────────────────────────────────────────────────────
ALTER TABLE tallas ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_tallas" ON tallas;
CREATE POLICY "anon_all_tallas" ON tallas FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── colores ───────────────────────────────────────────────────
ALTER TABLE colores ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_colores" ON colores;
CREATE POLICY "anon_all_colores" ON colores FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── categorias ────────────────────────────────────────────────
ALTER TABLE categorias ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_categorias" ON categorias;
CREATE POLICY "anon_all_categorias" ON categorias FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── proveedores ───────────────────────────────────────────────
ALTER TABLE proveedores ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_proveedores" ON proveedores;
CREATE POLICY "anon_all_proveedores" ON proveedores FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── clientes ──────────────────────────────────────────────────
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_clientes" ON clientes;
CREATE POLICY "anon_all_clientes" ON clientes FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── ventas ────────────────────────────────────────────────────
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_ventas" ON ventas;
CREATE POLICY "anon_all_ventas" ON ventas FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── detalle_venta ─────────────────────────────────────────────
ALTER TABLE detalle_venta ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_detalle_venta" ON detalle_venta;
CREATE POLICY "anon_all_detalle_venta" ON detalle_venta FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── movimientos_inventario ────────────────────────────────────
ALTER TABLE movimientos_inventario ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_movimientos" ON movimientos_inventario;
CREATE POLICY "anon_all_movimientos" ON movimientos_inventario FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── alertas_ia ────────────────────────────────────────────────
ALTER TABLE alertas_ia ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_alertas_ia" ON alertas_ia;
CREATE POLICY "anon_all_alertas_ia" ON alertas_ia FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── comisiones_venta ──────────────────────────────────────────
ALTER TABLE comisiones_venta ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_comisiones" ON comisiones_venta;
CREATE POLICY "anon_all_comisiones" ON comisiones_venta FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── lotes (tabla nueva) ───────────────────────────────────────
ALTER TABLE lotes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_lotes" ON lotes;
CREATE POLICY "anon_all_lotes" ON lotes FOR ALL TO anon USING (true) WITH CHECK (true);

-- ────────────────────────────────────────────────────────────────
-- PARTE 3 — Storage bucket "productos" para imágenes
-- ────────────────────────────────────────────────────────────────
INSERT INTO storage.buckets (id, name, public)
VALUES ('productos', 'productos', true)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "productos_upload"       ON storage.objects;
DROP POLICY IF EXISTS "productos_public_read"  ON storage.objects;
DROP POLICY IF EXISTS "productos_update"       ON storage.objects;

CREATE POLICY "productos_upload"      ON storage.objects FOR INSERT TO anon WITH CHECK (bucket_id = 'productos');
CREATE POLICY "productos_public_read" ON storage.objects FOR SELECT TO public USING (bucket_id = 'productos');
CREATE POLICY "productos_update"      ON storage.objects FOR UPDATE TO anon USING (bucket_id = 'productos');
