-- ============================================================
-- BARATELY — Migración WhatsApp Bot
-- Ejecutar en Supabase SQL Editor
-- ============================================================

-- ── 1. Extender tabla clientes ────────────────────────────
ALTER TABLE clientes
  ADD COLUMN IF NOT EXISTS direccion      TEXT,
  ADD COLUMN IF NOT EXISTS ciudad         TEXT,
  ADD COLUMN IF NOT EXISTS referencia     TEXT,
  ADD COLUMN IF NOT EXISTS fuente         TEXT DEFAULT 'web',
  ADD COLUMN IF NOT EXISTS primera_visita TIMESTAMPTZ DEFAULT NOW();

-- ── 2. Tabla de pedidos WhatsApp ──────────────────────────
CREATE TABLE IF NOT EXISTS pedidos_whatsapp (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Quién pide
  whatsapp         TEXT NOT NULL,
  nombre_cliente   TEXT,
  cliente_id       UUID REFERENCES clientes(id) ON DELETE SET NULL,

  -- Qué pide
  productos        TEXT NOT NULL,
  total_estimado   NUMERIC(10,2),

  -- Cómo lo recibe
  tipo_entrega     TEXT NOT NULL DEFAULT 'tienda'
                     CHECK (tipo_entrega IN ('tienda', 'envio')),
  direccion_envio  TEXT,
  ciudad_envio     TEXT,
  referencia_envio TEXT,
  hora_retiro      TEXT,

  -- Pago
  metodo_pago      TEXT,
                   -- 'efectivo' | 'tarjeta' | 'transferencia'

  -- ── COMPROBANTE DE PAGO ──────────────────────────────────
  -- URL pública de la imagen guardada en Supabase Storage
  comprobante_url        TEXT,

  -- Estado de verificación del pago (independiente del estado del pedido)
  estado_pago            TEXT NOT NULL DEFAULT 'pendiente'
                           CHECK (estado_pago IN (
                             'pendiente',          -- aún no han pagado / no han enviado foto
                             'comprobante_enviado', -- cliente envió la foto, encargado no la ha visto
                             'pago_verificado',     -- encargado confirmó que el pago es válido
                             'pago_rechazado'       -- foto no válida o pago no reconocido
                           )),

  comprobante_recibido_en TIMESTAMPTZ,              -- cuándo llegó la foto
  pago_verificado_en      TIMESTAMPTZ,              -- cuándo lo aprobó el encargado
  -- ────────────────────────────────────────────────────────

  -- Estado del pedido (flujo operativo)
  estado           TEXT NOT NULL DEFAULT 'pendiente'
                     CHECK (estado IN (
                       'pendiente',    -- recién creado
                       'confirmado',   -- encargado lo revisó
                       'en_proceso',   -- preparando el pedido
                       'listo',        -- listo para retiro o envío
                       'entregado',    -- completado
                       'cancelado'
                     )),

  -- Trazabilidad
  atendido_por     UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  notas            TEXT,
  conversacion_id  TEXT,

  creado_en        TIMESTAMPTZ DEFAULT NOW(),
  actualizado_en   TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_pedidos_wa_whatsapp   ON pedidos_whatsapp(whatsapp);
CREATE INDEX IF NOT EXISTS idx_pedidos_wa_estado      ON pedidos_whatsapp(estado);
CREATE INDEX IF NOT EXISTS idx_pedidos_wa_estado_pago ON pedidos_whatsapp(estado_pago);
CREATE INDEX IF NOT EXISTS idx_pedidos_wa_fecha       ON pedidos_whatsapp(creado_en DESC);

-- Trigger actualizar timestamp
CREATE OR REPLACE FUNCTION fn_actualizar_timestamp()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.actualizado_en = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_pedidos_wa_ts ON pedidos_whatsapp;
CREATE TRIGGER trg_pedidos_wa_ts
  BEFORE UPDATE ON pedidos_whatsapp
  FOR EACH ROW EXECUTE FUNCTION fn_actualizar_timestamp();

-- ── 3. Storage bucket para comprobantes ───────────────────
-- Crear bucket público (las fotos las ve el encargado en el panel)
INSERT INTO storage.buckets (id, name, public)
VALUES ('comprobantes', 'comprobantes', true)
ON CONFLICT (id) DO NOTHING;

-- Política: anon puede subir imágenes al bucket
CREATE POLICY "anon_upload_comprobantes"
  ON storage.objects FOR INSERT TO anon
  WITH CHECK (bucket_id = 'comprobantes');

CREATE POLICY "anon_read_comprobantes"
  ON storage.objects FOR SELECT TO anon
  USING (bucket_id = 'comprobantes');

-- ── 4. RLS tablas ─────────────────────────────────────────
ALTER TABLE pedidos_whatsapp ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_select_pedidos_wa" ON pedidos_whatsapp
  FOR SELECT TO anon USING (true);

CREATE POLICY "anon_insert_pedidos_wa" ON pedidos_whatsapp
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_update_pedidos_wa" ON pedidos_whatsapp
  FOR UPDATE TO anon USING (true);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'clientes' AND policyname = 'anon_insert_clientes'
  ) THEN
    CREATE POLICY "anon_insert_clientes" ON clientes
      FOR INSERT TO anon WITH CHECK (true);
  END IF;
END $$;

-- ── 5. Vista para panel encargado ─────────────────────────
CREATE OR REPLACE VIEW vw_pedidos_whatsapp_pendientes AS
SELECT
  p.id,
  p.creado_en,
  p.whatsapp,
  p.nombre_cliente,
  p.productos,
  p.total_estimado,
  p.tipo_entrega,
  CASE
    WHEN p.tipo_entrega = 'envio'
      THEN COALESCE(p.direccion_envio || ', ' || p.ciudad_envio, p.direccion_envio)
    ELSE 'Retira en tienda — ' || COALESCE(p.hora_retiro, 'sin hora')
  END                          AS entrega_detalle,
  p.metodo_pago,
  p.estado_pago,
  p.comprobante_url,           -- encargado puede ver la foto directamente
  p.comprobante_recibido_en,
  p.estado,
  p.notas
FROM pedidos_whatsapp p
WHERE p.estado IN ('pendiente', 'confirmado', 'en_proceso')
ORDER BY
  -- Prioriza los que ya enviaron comprobante pero no se han verificado
  (p.estado_pago = 'comprobante_enviado') DESC,
  p.creado_en DESC;

ALTER VIEW vw_pedidos_whatsapp_pendientes OWNER TO postgres;

-- ── 6. Verificar ──────────────────────────────────────────
SELECT 'Migración WhatsApp con comprobantes completada' AS resultado;
