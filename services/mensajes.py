"""
BARATELY Bot v2 — services/mensajes.py
Formateo de mensajes y teclados del bot.
"""
from datetime import datetime
from telegram import ReplyKeyboardMarkup, ReplyKeyboardRemove


# ── Formato ───────────────────────────────────────────────────
def q(monto) -> str:
    try:
        return f"Q{float(monto):,.2f}"
    except Exception:
        return "Q0.00"

def turno_actual() -> str:
    hora = datetime.now().hour
    if hora < 12:  return "manana"
    if hora < 18:  return "tarde"
    return "noche"

def hora_actual() -> str:
    return datetime.now().strftime("%H:%M")

def fecha_hoy() -> str:
    return datetime.now().strftime("%d/%m/%Y")


# ── Menú ──────────────────────────────────────────────────────
def texto_menu(rol: str) -> str:
    msg  = "📋 *Menu BARATELY*\n\n"
    msg += "1 — 🛒 Registrar venta\n"
    msg += "2 — 📊 Mis ventas de hoy\n"
    msg += "3 — 🔍 Consultar stock\n"
    msg += "4 — 💵 Solicitar vale\n"
    if rol in ("admin", "encargado"):
        msg += "5 — 📈 Resumen del dia\n"
        msg += "6 — 🔔 Alertas IA\n"
    msg += "0 — 🚪 Cerrar sesion"
    return msg

def teclado_menu(rol: str) -> ReplyKeyboardMarkup:
    opciones = [["1", "2"], ["3", "4"]]
    if rol in ("admin", "encargado"):
        opciones.append(["5", "6"])
    opciones.append(["0"])
    return ReplyKeyboardMarkup(opciones, resize_keyboard=True)

def teclado_cancelar() -> ReplyKeyboardMarkup:
    # IMPORTANTE: debe coincidir exactamente con los checks "❌ Cancelar" en los handlers
    return ReplyKeyboardMarkup([["❌ Cancelar"]], resize_keyboard=True)

def teclado_si_no() -> ReplyKeyboardMarkup:
    return ReplyKeyboardMarkup([["✅ Si", "❌ No"]], resize_keyboard=True)

def sin_teclado() -> ReplyKeyboardRemove:
    return ReplyKeyboardRemove()


# ── Mensajes estándar ─────────────────────────────────────────
MSG_BIENVENIDA = (
    "👕 *BARATELY — Sistema de Ventas*\n"
    "📍 19 calle 1-52 Zona 3, Guatemala\n\n"
    "Para acceder escribe tu *clave personal*:"
)

MSG_SESION_EXPIRADA = "⏱ Tu sesion expiro. Escribe /start para volver a entrar."
MSG_SIN_PERMISO     = "⛔ No tienes permiso para esta accion."
MSG_ERROR_GENERAL   = "⚠️ Ocurrio un error. Intenta de nuevo o escribe /start."
MSG_CANCELADO       = "❌ Operacion cancelada."


# ── Iconos de alerta ──────────────────────────────────────────
ICONOS_ALERTA = {
    "stock_critico":        "🔴 STOCK CRITICO",
    "temporada_proxima":    "📅 TEMPORADA",
    "producto_muerto":      "💀 SIN MOVIMIENTO",
    "cliente_inactivo":     "👤 CLIENTE INACTIVO",
    "reorden_sugerido":     "📦 REORDEN",
    "rendimiento_vendedor": "📊 RENDIMIENTO",
    "meta_cumplida":        "🏆 META CUMPLIDA",
    "combo_oportunidad":    "💡 COMBO",
    "proveedor_alerta":     "🏭 PROVEEDOR",
}


# ── Formatters ────────────────────────────────────────────────
def formato_venta_resumen(items: list, pagos: list, cliente_nombre: str) -> str:
    total  = sum(i["subtotal"] for i in items)
    pagado = sum(p["monto"] for p in pagos)
    cambio = pagado - total

    msg  = "🧾 *Resumen de venta*\n"
    msg += f"👤 Cliente: {cliente_nombre}\n"
    msg += "─────────────────────\n"
    for it in items:
        color = f" {it['color']}" if it.get("color") else ""
        msg += f"• {it['nombre']} T:{it['talla']}{color}\n"
        msg += f"  {it['cantidad']} x {q(it['precio_unitario'])} = *{q(it['subtotal'])}*\n"
    msg += "─────────────────────\n"
    msg += f"💰 *TOTAL: {q(total)}*\n\n"
    msg += "💳 Pagos:\n"
    for p in pagos:
        msg += f"  • {p['nombre'].capitalize()}: {q(p['monto'])}\n"
    if cambio > 0.009:
        msg += f"\n💵 *Cambio: {q(cambio)}*\n"
    return msg


def formato_mis_ventas(ventas: list) -> str:
    if not ventas:
        return "📭 No tienes ventas registradas hoy."
    total = sum(float(v["total"]) for v in ventas)
    msg   = f"📊 *Tus ventas de hoy — {fecha_hoy()}*\n\n"
    for i, v in enumerate(ventas, 1):
        hora  = v["fecha"][11:16] if v.get("fecha") else "--:--"
        turno = v.get("turno", "")
        msg  += f"  {i}. {hora} ({turno}) — *{q(v['total'])}*\n"
    msg += f"\n💰 *Total: {q(total)}*  |  {len(ventas)} ventas"
    return msg


def formato_resumen_dia(data: list) -> str:
    if not data:
        return "📭 Sin ventas registradas hoy."
    total_ventas = sum(float(r.get("total_vendido") or 0) for r in data)
    total_vales  = sum(float(r.get("vales_del_dia") or 0) for r in data)
    num_g        = sum(int(r.get("num_ventas") or 0) for r in data)
    msg = f"📈 *Resumen del dia — {fecha_hoy()}*\n\n"
    for r in data:
        tv   = float(r.get("total_vendido") or 0)
        vale = float(r.get("vales_del_dia") or 0)
        if tv > 0 or vale > 0:
            msg += f"👤 *{r.get('vendedor', '?')}*\n"
            if tv > 0:
                msg += f"   Ventas: {r.get('num_ventas', 0)} | {q(tv)}\n"
            if vale > 0:
                msg += f"   Vale aprobado: {q(vale)}\n"
            msg += "\n"
    msg += "─────────────────────\n"
    msg += f"💰 *Ventas: {q(total_ventas)}* | {num_g} transacciones\n"
    if total_vales > 0:
        msg += f"💵 *Vales aprobados: {q(total_vales)}*\n"
        msg += f"📊 *Neto del dia: {q(total_ventas - total_vales)}*"
    return msg


def formato_alertas(alertas: list) -> str:
    if not alertas:
        return "✅ Sin alertas pendientes."
    msg = f"🔔 *Alertas IA ({len(alertas)})*\n\n"
    for a in alertas:
        tipo = ICONOS_ALERTA.get(a.get("tipo", ""), "⚠️ ALERTA")
        prio = a.get("prioridad", "")
        prio_txt = " 🔴" if prio == "alta" else " 🟡" if prio == "media" else ""
        msg += f"{tipo}{prio_txt}\n"
        msg += f"*{a.get('titulo', '')}*\n"
        msg += f"_{a.get('mensaje', '')}_\n\n"
    return msg
