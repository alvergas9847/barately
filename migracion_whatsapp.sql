-- ============================================================
-- BARATELY — Migración WhatsApp Bot
-- Ejecutar en Supabase SQL Editor
-- ============================================================

-- ── 1. Extender tabla clientes ────────────────────────────
-- Agregar campos que el bot de WhatsApp recopilará

ALTER TABLE clientes
  ADD COLUMN IF NOT EXISTS direccion      TEXT,
  ADD COLUMN IF NOT EXISTS ciudad         TEXT,
  ADD COLUMN IF NOT EXISTS referencia     TEXT,   -- ej. "frente al parque"
  ADD COLUMN IF NOT EXISTS fuente         TEXT DEFAULT 'web',
                                                  -- 'web' | 'whatsapp' | 'telegram'
  ADD COLUMN IF NOT EXISTS primera_visita TIMESTAMPTZ DEFAULT NOW();

-- ── 2. Tabla de pedidos WhatsApp ──────────────────────────
CREATE TABLE IF NOT EXISTS pedidos_whatsapp (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Quién pide
  whatsapp         TEXT NOT NULL,               -- número completo ej. 50212345678
  nombre_cliente   TEXT,
  cliente_id       UUID REFERENCES clientes(id) ON DELETE SET NULL,

  -- Qué pide (texto libre que registra la IA)
  productos        TEXT NOT NULL,               -- "3 boxers talla M color negro"
  total_estimado   NUMERIC(10,2),

  -- Cómo lo recibe
  tipo_entrega     TEXT NOT NULL DEFAULT 'tienda'
                     CHECK (tipo_entrega IN ('tienda', 'envio')),
  direccion_envio  TEXT,                        -- si tipo_entrega = 'envio'
  ciudad_envio     TEXT,
  referencia_envio TEXT,
  hora_retiro      TEXT,                        -- si tipo_entrega = 'tienda'

  -- Pago
  metodo_pago      TEXT,                        -- 'efectivo' | 'tarjeta' | 'transferencia'

  -- Estado del pedido
  estado           TEXT NOT NULL DEFAULT 'pendiente'
                     CHECK (estado IN (
                       'pendiente',    -- recién creado por el bot
                       'confirmado',   -- encargado lo revisó
                       'en_proceso',   -- se está preparando
                       'listo',        -- listo para entrega/retiro
                       'entregado',    -- completado
                       'cancelado'
                     )),

  -- Trazabilidad
  atendido_por     UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  notas            TEXT,                        -- observaciones del encargado
  conversacion_id  TEXT,                        -- ID de la conv en ManyChat

  creado_en        TIMESTAMPTZ DEFAULT NOW(),
  actualizado_en   TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para búsquedas frecuentes
CREATE INDEX IF NOT EXISTS idx_pedidos_wa_whatsapp ON pedidos_whatsapp(whatsapp);
CREATE INDEX IF NOT EXISTS idx_pedidos_wa_estado   ON pedidos_whatsapp(estado);
CREATE INDEX IF NOT EXISTS idx_pedidos_wa_fecha     ON pedidos_whatsapp(creado_en DESC);

-- Trigger: actualiza "actualizado_en" automáticamente
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

-- ── 3. RLS — permite acceso desde anon key ────────────────
ALTER TABLE pedidos_whatsapp ENABLE ROW LEVEL SECURITY;

-- El bot y el panel web usan la anon key → necesitan todos los permisos
CREATE POLICY "anon_select_pedidos_wa" ON pedidos_whatsapp
  FOR SELECT TO anon USING (true);

CREATE POLICY "anon_insert_pedidos_wa" ON pedidos_whatsapp
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_update_pedidos_wa" ON pedidos_whatsapp
  FOR UPDATE TO anon USING (true);

-- También extender RLS de clientes para INSERT desde WhatsApp
-- (en caso de que sea cliente nuevo que el bot registra)
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

-- ── 4. Vista para panel de encargado ──────────────────────
-- Muestra todos los pedidos WhatsApp pendientes con datos del cliente
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
  END AS entrega_detalle,
  p.metodo_pago,
  p.estado,
  p.notas
FROM pedidos_whatsapp p
WHERE p.estado IN ('pendiente', 'confirmado', 'en_proceso')
ORDER BY p.creado_en DESC;

-- RLS en la vista
ALTER VIEW vw_pedidos_whatsapp_pendientes OWNER TO postgres;

-- ── 5. Verificar ──────────────────────────────────────────
SELECT 'Migración WhatsApp completada correctamente' AS resultado;
