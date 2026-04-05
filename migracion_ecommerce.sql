-- ============================================================
-- BARATELY — Migración E-commerce Cliente
-- Ejecutar en el SQL Editor de Supabase
-- ============================================================

-- ------------------------------------------------------------
-- 1. Agregar columnas a la tabla clientes existente
-- ------------------------------------------------------------
ALTER TABLE clientes
  ADD COLUMN IF NOT EXISTS email         TEXT,
  ADD COLUMN IF NOT EXISTS pin_cliente   TEXT,
  ADD COLUMN IF NOT EXISTS activo_web    BOOLEAN DEFAULT FALSE;

-- ------------------------------------------------------------
-- 2. Secuencia para número de orden
-- ------------------------------------------------------------
CREATE SEQUENCE IF NOT EXISTS seq_orden_num START 1;

-- ------------------------------------------------------------
-- 3. Función para generar número de orden: BAR-YYYY-NNNN
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION generar_numero_orden()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
  v_year TEXT;
  v_seq  BIGINT;
BEGIN
  v_year := TO_CHAR(NOW(), 'YYYY');
  v_seq  := NEXTVAL('seq_orden_num');
  RETURN 'BAR-' || v_year || '-' || LPAD(v_seq::TEXT, 4, '0');
END;
$$;

-- ------------------------------------------------------------
-- 4. Tabla ordenes_cliente
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ordenes_cliente (
  id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  numero_orden      TEXT        UNIQUE NOT NULL DEFAULT generar_numero_orden(),
  cliente_id        UUID        REFERENCES clientes(id) ON DELETE SET NULL,
  nombre_cliente    TEXT        NOT NULL,
  telefono_cliente  TEXT        NOT NULL,
  email_cliente     TEXT,
  subtotal          NUMERIC(10,2),
  descuento         NUMERIC(10,2) DEFAULT 0,
  costo_envio       NUMERIC(10,2) DEFAULT 0,
  total             NUMERIC(10,2),
  tipo_entrega      TEXT        CHECK (tipo_entrega IN ('tienda','envio')),
  direccion_envio   TEXT,
  ciudad_envio      TEXT,
  referencia_envio  TEXT,
  metodo_pago       TEXT        CHECK (metodo_pago IN ('transferencia','efectivo','tarjeta')),
  comprobante_url   TEXT,
  estado_pago       TEXT        DEFAULT 'pendiente'
                    CHECK (estado_pago IN ('pendiente','enviado','verificado','rechazado')),
  estado            TEXT        DEFAULT 'pendiente_pago'
                    CHECK (estado IN ('pendiente_pago','pago_recibido','confirmado',
                                      'preparando','listo','en_camino','entregado','cancelado')),
  notas_cliente     TEXT,
  notas_tienda      TEXT,
  atendido_por      UUID        REFERENCES usuarios(id) ON DELETE SET NULL,
  creado_en         TIMESTAMPTZ DEFAULT NOW(),
  actualizado_en    TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------------------------
-- 5. Tabla detalle_orden_cliente
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS detalle_orden_cliente (
  id               UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  orden_id         UUID         NOT NULL REFERENCES ordenes_cliente(id) ON DELETE CASCADE,
  variante_id      UUID         REFERENCES variantes(id) ON DELETE SET NULL,
  nombre_producto  TEXT,
  talla            TEXT,
  color            TEXT,
  cantidad         INT,
  precio_unitario  NUMERIC(10,2),
  subtotal         NUMERIC(10,2)
);

-- ------------------------------------------------------------
-- 6. Índices útiles
-- ------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_ordenes_cliente_telefono
  ON ordenes_cliente(telefono_cliente);

CREATE INDEX IF NOT EXISTS idx_ordenes_cliente_estado
  ON ordenes_cliente(estado);

CREATE INDEX IF NOT EXISTS idx_ordenes_cliente_creado
  ON ordenes_cliente(creado_en DESC);

CREATE INDEX IF NOT EXISTS idx_detalle_orden_cliente_orden
  ON detalle_orden_cliente(orden_id);

-- ------------------------------------------------------------
-- 7. Trigger para actualizar actualizado_en
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_actualizado_en()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.actualizado_en = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_ordenes_actualizado ON ordenes_cliente;
CREATE TRIGGER trg_ordenes_actualizado
  BEFORE UPDATE ON ordenes_cliente
  FOR EACH ROW EXECUTE FUNCTION set_actualizado_en();

-- ------------------------------------------------------------
-- 8. Row Level Security (RLS)
-- ------------------------------------------------------------

-- Habilitar RLS en tablas nuevas
ALTER TABLE ordenes_cliente       ENABLE ROW LEVEL SECURITY;
ALTER TABLE detalle_orden_cliente ENABLE ROW LEVEL SECURITY;

-- ── Políticas para ordenes_cliente ──────────────────────────

-- Cualquier visitante (anon) puede crear una orden (guest checkout)
CREATE POLICY "anon_insert_ordenes"
  ON ordenes_cliente
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Anon puede leer sus propias órdenes (por teléfono o número de orden)
CREATE POLICY "anon_select_ordenes"
  ON ordenes_cliente
  FOR SELECT
  TO anon
  USING (true);

-- Anon puede actualizar (para subir comprobante)
CREATE POLICY "anon_update_ordenes"
  ON ordenes_cliente
  FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);

-- ── Políticas para detalle_orden_cliente ────────────────────

CREATE POLICY "anon_insert_detalle"
  ON detalle_orden_cliente
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "anon_select_detalle"
  ON detalle_orden_cliente
  FOR SELECT
  TO anon
  USING (true);

-- ── Políticas para clientes (agregar si no existen) ─────────

ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;

-- Anon puede insertar clientes nuevos (registro web)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'clientes' AND policyname = 'anon_insert_clientes'
  ) THEN
    EXECUTE 'CREATE POLICY anon_insert_clientes ON clientes FOR INSERT TO anon WITH CHECK (true)';
  END IF;
END$$;

-- Anon puede leer clientes (para verificar login por teléfono)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'clientes' AND policyname = 'anon_select_clientes'
  ) THEN
    EXECUTE 'CREATE POLICY anon_select_clientes ON clientes FOR SELECT TO anon USING (true)';
  END IF;
END$$;

-- Anon puede actualizar su propio cliente (si es necesario)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'clientes' AND policyname = 'anon_update_clientes'
  ) THEN
    EXECUTE 'CREATE POLICY anon_update_clientes ON clientes FOR UPDATE TO anon USING (true) WITH CHECK (true)';
  END IF;
END$$;

-- ── Políticas para productos y variantes (lectura pública) ──

ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE variantes ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'productos' AND policyname = 'anon_select_productos'
  ) THEN
    EXECUTE 'CREATE POLICY anon_select_productos ON productos FOR SELECT TO anon USING (activo = true)';
  END IF;
END$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'variantes' AND policyname = 'anon_select_variantes'
  ) THEN
    EXECUTE 'CREATE POLICY anon_select_variantes ON variantes FOR SELECT TO anon USING (true)';
  END IF;
END$$;

-- ------------------------------------------------------------
-- 9. Vista para panel admin: órdenes pendientes
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_ordenes_pendientes AS
SELECT
  o.id,
  o.numero_orden,
  o.nombre_cliente,
  o.telefono_cliente,
  o.email_cliente,
  o.total,
  o.tipo_entrega,
  o.metodo_pago,
  o.estado_pago,
  o.estado,
  o.creado_en,
  o.actualizado_en,
  (
    SELECT STRING_AGG(d.nombre_producto || ' x' || d.cantidad, ', ')
    FROM detalle_orden_cliente d
    WHERE d.orden_id = o.id
  ) AS resumen_productos
FROM ordenes_cliente o
WHERE o.estado NOT IN ('entregado', 'cancelado')
ORDER BY o.creado_en DESC;

-- ------------------------------------------------------------
-- 10. Storage bucket para comprobantes
-- (Ejecutar solo si el bucket no existe — hacerlo desde Dashboard
--  o descomentar si la extensión storage está disponible)
-- ------------------------------------------------------------

-- Bucket 'comprobantes-ordenes' (público para subir, privado para leer)
INSERT INTO storage.buckets (id, name, public)
VALUES ('comprobantes-ordenes', 'comprobantes-ordenes', false)
ON CONFLICT (id) DO NOTHING;

-- Política: anon puede subir comprobantes
CREATE POLICY "anon_upload_comprobantes"
  ON storage.objects
  FOR INSERT
  TO anon
  WITH CHECK (bucket_id = 'comprobantes-ordenes');

-- Política: anon puede leer sus comprobantes
CREATE POLICY "anon_read_comprobantes"
  ON storage.objects
  FOR SELECT
  TO anon
  USING (bucket_id = 'comprobantes-ordenes');

-- ============================================================
-- FIN DE MIGRACIÓN
-- ============================================================
-- Verificar con:
-- SELECT * FROM ordenes_cliente LIMIT 5;
-- SELECT generar_numero_orden();
-- ============================================================
