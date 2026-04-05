"""
BARATELY Bot v2 — handlers/ventas.py
Flujo completo de registro de ventas.
"""
from telegram import Update, ReplyKeyboardMarkup
from telegram.ext import ContextTypes, ConversationHandler
from services import supabase_svc as db
from services.mensajes import (
    q, teclado_menu, teclado_cancelar, sin_teclado,
    turno_actual, hora_actual, formato_venta_resumen
)
from handlers.auth import usuario_actual, verificar_sesion
from config.settings import logger

# Estados del flujo de venta
(
    VENTA_CLIENTE,
    VENTA_PRODUCTO,
    VENTA_TALLA,
    VENTA_CANTIDAD,
    VENTA_MAS_PRODUCTOS,
    VENTA_METODO_PAGO,
    VENTA_MONTO_PAGO,
    VENTA_CONFIRMAR,
) = range(10, 18)

# Texto del botón para "venta general" (debe coincidir exactamente)
BTN_GENERAL  = "👤 Venta general"
BTN_TERMINAR = "✅ Terminar venta"
BTN_AGREGAR  = "➕ Agregar producto"
BTN_CONFIRMAR = "✅ CONFIRMAR"
BTN_CANCELAR  = "❌ CANCELAR"


# ── Helpers ───────────────────────────────────────────────────

def init_venta(ctx: ContextTypes.DEFAULT_TYPE):
    ctx.user_data["venta"] = {
        "items":          [],
        "pagos":          [],
        "cliente_id":     None,
        "cliente_nombre": "General",
    }


def venta_actual(ctx: ContextTypes.DEFAULT_TYPE) -> dict:
    """Devuelve el dict de venta activo, re-inicializando si falta."""
    if "venta" not in ctx.user_data:
        init_venta(ctx)
    return ctx.user_data["venta"]


def _es_cancelar(texto: str) -> bool:
    return texto in ("❌ Cancelar", BTN_CANCELAR)


async def _cancelar(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    usuario = usuario_actual(ctx)
    await update.message.reply_text(
        "❌ Operación cancelada.",
        reply_markup=teclado_menu(usuario["rol"]) if usuario else sin_teclado()
    )
    return 1  # MENU_PRINCIPAL


# ── PASO 1: Cliente ───────────────────────────────────────────

async def iniciar_venta(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    if not await verificar_sesion(update, ctx):
        return ConversationHandler.END

    init_venta(ctx)
    await update.message.reply_text(
        "🛒 *Nueva Venta — Paso 1/5*\n\n"
        "¿A quién le vendemos?\n"
        "• Toca *Venta general* si no tiene cuenta\n"
        "• O escribe su *nombre o teléfono* para buscarlo",
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(
            [[BTN_GENERAL], ["❌ Cancelar"]],
            resize_keyboard=True
        )
    )
    return VENTA_CLIENTE


async def venta_cliente(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    if not await verificar_sesion(update, ctx):
        return ConversationHandler.END

    texto   = update.message.text.strip()
    usuario = usuario_actual(ctx)

    if _es_cancelar(texto):
        return await _cancelar(update, ctx)

    venta = venta_actual(ctx)

    if texto == BTN_GENERAL or texto.upper() == "GENERAL":
        venta["cliente_nombre"] = "General"
        venta["cliente_id"]     = None
    else:
        clientes = db.buscar_cliente(texto)
        if clientes:
            c = clientes[0]
            venta["cliente_id"]     = c["id"]
            venta["cliente_nombre"] = f"{c['nombre']} {c.get('apellidos','')  }".strip()
            historial = db.ultimas_compras(c["id"])
            msg = f"✅ Cliente: *{venta['cliente_nombre']}*\n\n"
            if historial:
                msg += "📋 *Últimas compras:*\n"
                for h in historial:
                    msg += f"  • {h.get('fecha','')[:10]} — {q(h.get('total',0))}\n"
            else:
                msg += "_Sin compras anteriores_"
            await update.message.reply_text(msg, parse_mode="Markdown")
        else:
            venta["cliente_nombre"] = "General"
            venta["cliente_id"]     = None
            await update.message.reply_text(
                "ℹ️ Cliente no encontrado. Se registrará como venta general."
            )

    await update.message.reply_text(
        "🛒 *Paso 2/5 — Producto*\n\nEscribe el nombre o código del producto:",
        parse_mode="Markdown",
        reply_markup=teclado_cancelar()
    )
    return VENTA_PRODUCTO


# ── PASO 2: Buscar producto ───────────────────────────────────

async def venta_buscar_producto(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    if not await verificar_sesion(update, ctx):
        return ConversationHandler.END

    texto   = update.message.text.strip()
    usuario = usuario_actual(ctx)

    if _es_cancelar(texto):
        return await _cancelar(update, ctx)

    productos = db.buscar_producto(texto)
    if not productos:
        await update.message.reply_text(
            "❌ Producto no encontrado. Intenta con otro nombre o código:"
        )
        return VENTA_PRODUCTO

    ctx.user_data["productos_encontrados"] = productos
    kb = [[f"{p['nombre']} — {q(p['precio_venta'])}"] for p in productos]
    kb.append(["❌ Cancelar"])

    await update.message.reply_text(
        "Selecciona el producto:",
        reply_markup=ReplyKeyboardMarkup(kb, resize_keyboard=True)
    )
    return VENTA_TALLA


# ── PASO 3: Seleccionar talla ─────────────────────────────────

async def venta_seleccionar_producto(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    if not await verificar_sesion(update, ctx):
        return ConversationHandler.END

    texto    = update.message.text.strip()
    usuario  = usuario_actual(ctx)
    productos = ctx.user_data.get("productos_encontrados", [])

    if _es_cancelar(texto):
        return await _cancelar(update, ctx)

    if texto == BTN_TERMINAR:
        if not venta_actual(ctx)["items"]:
            await update.message.reply_text("⚠️ Agrega al menos un producto antes de terminar.")
            return VENTA_TALLA
        return await pedir_pago(update, ctx)

    # Buscar producto por nombre (substring)
    producto = next((p for p in productos if p["nombre"] in texto), None)
    if not producto:
        await update.message.reply_text("Por favor selecciona un producto de la lista.")
        return VENTA_TALLA

    ctx.user_data["producto_actual"] = producto
    variantes = db.obtener_variantes(producto["id"])

    if not variantes:
        await update.message.reply_text(
            f"⚠️ *{producto['nombre']}* no tiene stock disponible.",
            parse_mode="Markdown"
        )
        return VENTA_TALLA

    ctx.user_data["variantes_disponibles"] = variantes
    kb = []
    for v in variantes:
        talla = (v.get("tallas") or {}).get("nombre", "?")
        color = (v.get("colores") or {}).get("nombre", "")
        label = f"T:{talla}"
        if color:
            label += f" {color}"
        label += f" (stock: {v['stock']})"
        kb.append([label])
    kb.append(["❌ Cancelar"])

    await update.message.reply_text(
        f"*{producto['nombre']}* — {q(producto['precio_venta'])}\n"
        "Selecciona la talla:",
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(kb, resize_keyboard=True)
    )
    return VENTA_CANTIDAD


# ── PASO 4: Cantidad ──────────────────────────────────────────

async def venta_seleccionar_talla(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    if not await verificar_sesion(update, ctx):
        return ConversationHandler.END

    texto     = update.message.text.strip()
    variantes = ctx.user_data.get("variantes_disponibles", [])

    if _es_cancelar(texto):
        return await _cancelar(update, ctx)

    variante = None
    for v in variantes:
        talla = (v.get("tallas") or {}).get("nombre", "?")
        color = (v.get("colores") or {}).get("nombre", "")
        if f"T:{talla}" in texto:
            if not color or color in texto:
                variante = v
                break

    if not variante:
        await update.message.reply_text("Selecciona una talla de la lista.")
        return VENTA_CANTIDAD

    ctx.user_data["variante_actual"] = variante
    await update.message.reply_text(
        f"¿Cuántas unidades? (disponibles: *{variante['stock']}*)",
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(
            [["1", "2", "3"], ["4", "5", "6"], ["❌ Cancelar"]],
            resize_keyboard=True
        )
    )
    return VENTA_MAS_PRODUCTOS


async def venta_cantidad(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    if not await verificar_sesion(update, ctx):
        return ConversationHandler.END

    texto    = update.message.text.strip()
    variante = ctx.user_data.get("variante_actual", {})
    producto = ctx.user_data.get("producto_actual", {})

    if _es_cancelar(texto):
        return await _cancelar(update, ctx)

    try:
        cantidad = int(texto)
        if cantidad <= 0:
            raise ValueError
    except ValueError:
        await update.message.reply_text("Escribe un número válido (mayor a 0).")
        return VENTA_MAS_PRODUCTOS

    stock_disp = variante.get("stock", 0)
    if cantidad > stock_disp:
        await update.message.reply_text(
            f"⚠️ Solo hay *{stock_disp}* unidades disponibles.",
            parse_mode="Markdown"
        )
        return VENTA_MAS_PRODUCTOS

    talla  = (variante.get("tallas") or {}).get("nombre", "?")
    color  = (variante.get("colores") or {}).get("nombre", "")
    precio = float(producto.get("precio_venta", 0))

    venta_actual(ctx)["items"].append({
        "variante_id":     variante["id"],
        "nombre":          producto["nombre"],
        "talla":           talla,
        "color":           color,
        "cantidad":        cantidad,
        "precio_unitario": precio,
        "subtotal":        cantidad * precio,
    })

    # Resumen del carrito
    items = venta_actual(ctx)["items"]
    total = sum(i["subtotal"] for i in items)
    msg   = "🛒 *Carrito actual:*\n"
    for it in items:
        c    = f" {it['color']}" if it.get("color") else ""
        msg += f"  • {it['nombre']} T:{it['talla']}{c} ×{it['cantidad']} = *{q(it['subtotal'])}*\n"
    msg += f"\n💰 *Subtotal: {q(total)}*"

    await update.message.reply_text(
        msg + "\n\n¿Agregar otro producto o terminar?",
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(
            [[BTN_AGREGAR, BTN_TERMINAR], ["❌ Cancelar"]],
            resize_keyboard=True
        )
    )
    return VENTA_METODO_PAGO


# ── PASO 5: Decisión ──────────────────────────────────────────

async def venta_decision(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    if not await verificar_sesion(update, ctx):
        return ConversationHandler.END

    texto = update.message.text.strip()

    if _es_cancelar(texto):
        return await _cancelar(update, ctx)

    if texto == BTN_AGREGAR:
        await update.message.reply_text(
            "Escribe el nombre o código del siguiente producto:",
            reply_markup=teclado_cancelar()
        )
        return VENTA_PRODUCTO

    if texto == BTN_TERMINAR:
        return await pedir_pago(update, ctx)

    await update.message.reply_text(
        f"Toca *{BTN_AGREGAR}* o *{BTN_TERMINAR}*.",
        parse_mode="Markdown"
    )
    return VENTA_METODO_PAGO


# ── PASO 5b: Método de pago ───────────────────────────────────

async def pedir_pago(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    items     = venta_actual(ctx)["items"]
    pagos     = venta_actual(ctx)["pagos"]
    total     = sum(i["subtotal"] for i in items)
    pagado    = sum(p["monto"] for p in pagos)
    pendiente = total - pagado

    if pendiente <= 0.01:
        return await confirmar_venta(update, ctx)

    metodos = db.obtener_metodos_pago()
    ctx.user_data["metodos_pago"] = metodos

    if not metodos:
        await update.message.reply_text(
            "⚠️ No hay métodos de pago configurados. Contacta al administrador."
        )
        return await _cancelar(update, ctx)

    kb = [[m["nombre"].capitalize()] for m in metodos]
    kb.append(["❌ Cancelar"])

    msg  = f"💳 *Total: {q(total)}*\n"
    if pagado > 0:
        msg += f"Registrado: {q(pagado)}\n"
        msg += f"*Pendiente: {q(pendiente)}*\n"
    msg += "\n🛒 *Paso 4/5 — Método de pago:*"

    await update.message.reply_text(
        msg,
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(kb, resize_keyboard=True)
    )
    return VENTA_MONTO_PAGO


async def venta_metodo(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    if not await verificar_sesion(update, ctx):
        return ConversationHandler.END

    texto   = update.message.text.strip()
    metodos = ctx.user_data.get("metodos_pago", [])

    if _es_cancelar(texto):
        return await _cancelar(update, ctx)

    metodo = next((m for m in metodos if m["nombre"].lower() == texto.lower()), None)
    if not metodo:
        await update.message.reply_text("Selecciona un método de pago de la lista.")
        return VENTA_MONTO_PAGO

    ctx.user_data["metodo_actual"] = metodo
    items     = venta_actual(ctx)["items"]
    pagos     = venta_actual(ctx)["pagos"]
    total     = sum(i["subtotal"] for i in items)
    pagado    = sum(p["monto"] for p in pagos)
    pendiente = total - pagado

    await update.message.reply_text(
        f"💳 *{metodo['nombre'].capitalize()}*\n"
        f"Pendiente: *{q(pendiente)}*\n\n"
        "Escribe el monto recibido:",
        parse_mode="Markdown",
        reply_markup=teclado_cancelar()
    )
    return VENTA_CONFIRMAR


async def venta_monto(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    if not await verificar_sesion(update, ctx):
        return ConversationHandler.END

    texto  = update.message.text.strip()
    metodo = ctx.user_data.get("metodo_actual", {})

    if _es_cancelar(texto):
        return await _cancelar(update, ctx)

    try:
        monto = float(texto.replace(",", "").replace("Q", "").strip())
        if monto <= 0:
            raise ValueError
    except ValueError:
        await update.message.reply_text(
            "Escribe un monto válido. Ejemplo: *150* o *1500.50*",
            parse_mode="Markdown"
        )
        return VENTA_CONFIRMAR

    venta_actual(ctx)["pagos"].append({
        "metodo_id": metodo.get("id"),
        "nombre":    metodo.get("nombre", ""),
        "monto":     monto,
        "banco":     metodo.get("banco"),
    })

    items     = venta_actual(ctx)["items"]
    pagos     = venta_actual(ctx)["pagos"]
    total     = sum(i["subtotal"] for i in items)
    pagado    = sum(p["monto"] for p in pagos)
    pendiente = total - pagado

    if pendiente > 0.01:
        metodos = db.obtener_metodos_pago()
        ctx.user_data["metodos_pago"] = metodos
        kb = [[m["nombre"].capitalize()] for m in metodos]
        kb.append(["❌ Cancelar"])
        await update.message.reply_text(
            f"✅ {metodo.get('nombre','').capitalize()}: {q(monto)} registrado.\n"
            f"*Pendiente: {q(pendiente)}*\n\n¿Otro método de pago?",
            parse_mode="Markdown",
            reply_markup=ReplyKeyboardMarkup(kb, resize_keyboard=True)
        )
        return VENTA_MONTO_PAGO

    return await confirmar_venta(update, ctx)


# ── PASO 6: Confirmar ─────────────────────────────────────────

async def confirmar_venta(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    venta   = venta_actual(ctx)
    resumen = formato_venta_resumen(
        venta["items"], venta["pagos"], venta["cliente_nombre"]
    )
    await update.message.reply_text(
        "🛒 *Paso 5/5 — Confirmar venta*\n\n" + resumen + "\n¿Todo correcto?",
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(
            [[BTN_CONFIRMAR, BTN_CANCELAR]],
            resize_keyboard=True
        )
    )
    return VENTA_CONFIRMAR


async def guardar_venta(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    if not await verificar_sesion(update, ctx):
        return ConversationHandler.END

    texto   = update.message.text.strip().upper()
    usuario = usuario_actual(ctx)
    venta   = venta_actual(ctx)

    if "CANCELAR" in texto:
        init_venta(ctx)
        await update.message.reply_text(
            "❌ Venta cancelada.",
            reply_markup=teclado_menu(usuario["rol"])
        )
        return 1

    if "CONFIRMAR" not in texto:
        return VENTA_CONFIRMAR

    venta_id = db.registrar_venta(
        usuario_id = usuario["id"],
        cliente_id = venta.get("cliente_id"),
        items      = venta["items"],
        pagos      = venta["pagos"],
        turno      = turno_actual()
    )

    if venta_id:
        total = sum(i["subtotal"] for i in venta["items"])
        await update.message.reply_text(
            f"✅ *¡Venta registrada exitosamente!*\n\n"
            f"👤 Cliente: {venta['cliente_nombre']}\n"
            f"💰 Total: *{q(total)}*\n"
            f"🕐 Hora: {hora_actual()}",
            parse_mode="Markdown",
            reply_markup=teclado_menu(usuario["rol"])
        )
        logger.info(f"Venta {venta_id} guardada por {usuario['nombre']}")
    else:
        await update.message.reply_text(
            "❌ Error al guardar la venta. Intenta de nuevo o contacta al administrador.",
            reply_markup=teclado_menu(usuario["rol"])
        )

    init_venta(ctx)
    return 1
