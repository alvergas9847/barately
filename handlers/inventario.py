"""
BARATELY Bot v2 — handlers/inventario.py
Consulta de stock, vales y reportes.
"""
from telegram import Update
from telegram.ext import ContextTypes
from services import supabase_svc as db
from services.mensajes import (
    q, teclado_menu, teclado_cancelar, sin_teclado,
    formato_mis_ventas, formato_resumen_dia, formato_alertas
)
from handlers.auth import usuario_actual, tiene_permiso
from config.settings import logger

# Estados
STOCK_BUSCAR  = 20
VALE_MONTO    = 21
VALE_MOTIVO   = 22


# ══════════════════════════════════════════════════════════════
# STOCK
# ══════════════════════════════════════════════════════════════

async def iniciar_stock(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    await update.message.reply_text(
        "🔍 *Consultar Stock*\n\nEscribe el nombre o código del producto:",
        parse_mode="Markdown",
        reply_markup=teclado_cancelar()
    )
    return STOCK_BUSCAR


async def buscar_stock(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    texto   = update.message.text.strip()
    usuario = usuario_actual(ctx)

    if texto == "❌ Cancelar":
        await update.message.reply_text("Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1

    productos = db.buscar_producto(texto)

    if not productos:
        await update.message.reply_text(
            "❌ Producto no encontrado. Intenta con otro nombre:",
            reply_markup=teclado_cancelar()
        )
        return STOCK_BUSCAR

    msg = ""
    for p in productos:
        msg += f"*{p['nombre']}* — {q(p['precio_venta'])}\n"
        variantes = db.obtener_variantes(p["id"])
        if variantes:
            for v in sorted(variantes, key=lambda x: x.get("tallas", {}).get("nombre", "") if x.get("tallas") else ""):
                talla = v.get("tallas", {}).get("nombre", "?") if v.get("tallas") else "?"
                color = v.get("colores", {}).get("nombre", "") if v.get("colores") else ""
                alerta = " ⚠️" if v["stock"] <= v["stock_minimo"] else ""
                color_txt = f" {color}" if color else ""
                msg += f"  T:{talla}{color_txt} → {v['stock']} uds{alerta}\n"
        else:
            msg += "  ⚠️ Sin stock disponible\n"
        msg += "\n"

    await update.message.reply_text(
        msg,
        parse_mode="Markdown",
        reply_markup=teclado_menu(usuario["rol"])
    )
    return 1


# ══════════════════════════════════════════════════════════════
# VALES
# ══════════════════════════════════════════════════════════════

async def iniciar_vale(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    await update.message.reply_text(
        "💵 *Solicitar Vale / Adelanto*\n\n¿Cuánto necesitas? (en Quetzales)\nEjemplo: 150",
        parse_mode="Markdown",
        reply_markup=teclado_cancelar()
    )
    return VALE_MONTO


async def vale_monto(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    texto   = update.message.text.strip()
    usuario = usuario_actual(ctx)

    if texto == "❌ Cancelar":
        await update.message.reply_text("Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1

    try:
        monto = float(texto.replace(",", "").replace("Q", "").strip())
        if monto <= 0:
            raise ValueError
    except ValueError:
        await update.message.reply_text("Escribe un monto válido. Ejemplo: 150")
        return VALE_MONTO

    ctx.user_data["vale_monto"] = monto
    await update.message.reply_text(
        f"Monto: *{q(monto)}*\n\n¿Motivo del vale?",
        parse_mode="Markdown",
        reply_markup=teclado_cancelar()
    )
    return VALE_MOTIVO


async def vale_motivo(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    texto   = update.message.text.strip()
    usuario = usuario_actual(ctx)

    if texto == "❌ Cancelar":
        await update.message.reply_text("Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1

    monto  = ctx.user_data.get("vale_monto", 0)
    exito  = db.solicitar_vale(usuario["id"], monto, texto)

    if exito:
        await update.message.reply_text(
            f"✅ *Vale solicitado*\n\n"
            f"Monto: {q(monto)}\n"
            f"Motivo: {texto}\n"
            f"Estado: _Pendiente de aprobación_\n\n"
            f"El encargado o administrador lo aprobará en breve.",
            parse_mode="Markdown",
            reply_markup=teclado_menu(usuario["rol"])
        )
        logger.info(f"Vale solicitado: {usuario['nombre']} — {q(monto)}")
    else:
        await update.message.reply_text(
            "❌ Error al registrar el vale. Intenta de nuevo.",
            reply_markup=teclado_menu(usuario["rol"])
        )
    return 1


# ══════════════════════════════════════════════════════════════
# REPORTES (solo admin/encargado)
# ══════════════════════════════════════════════════════════════

async def mis_ventas(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    usuario = usuario_actual(ctx)
    ventas  = db.ventas_del_dia(usuario["id"])
    await update.message.reply_text(
        formato_mis_ventas(ventas),
        parse_mode="Markdown",
        reply_markup=teclado_menu(usuario["rol"])
    )
    return 1


async def resumen_dia(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    usuario = usuario_actual(ctx)
    if not tiene_permiso(usuario, ["admin", "encargado"]):
        await update.message.reply_text("⛔ Sin permiso.")
        return 1
    data = db.resumen_dia()
    await update.message.reply_text(
        formato_resumen_dia(data),
        parse_mode="Markdown",
        reply_markup=teclado_menu(usuario["rol"])
    )
    return 1


async def ver_alertas(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    usuario = usuario_actual(ctx)
    if not tiene_permiso(usuario, ["admin", "encargado"]):
        await update.message.reply_text("⛔ Sin permiso.")
        return 1
    alertas = db.alertas_pendientes()
    await update.message.reply_text(
        formato_alertas(alertas),
        parse_mode="Markdown",
        reply_markup=teclado_menu(usuario["rol"])
    )
    return 1
