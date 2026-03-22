"""
BARATELY Bot v2 — handlers/ventas.py
Flujo completo de registro de ventas.
"""
from telegram import Update, ReplyKeyboardMarkup
from telegram.ext import ContextTypes
from services import supabase_svc as db
from services.mensajes import (
    q, teclado_menu, teclado_cancelar, sin_teclado,
    turno_actual, hora_actual, formato_venta_resumen
)
from handlers.auth import usuario_actual
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


def init_venta(ctx: ContextTypes.DEFAULT_TYPE):
    """Inicializa el carrito de venta en el contexto."""
    ctx.user_data["venta"] = {
        "items":         [],
        "pagos":         [],
        "cliente_id":    None,
        "cliente_nombre": "General"
    }


def venta_actual(ctx) -> dict:
    return ctx.user_data.get("venta", {})


# ── PASO 1: Buscar cliente ────────────────────────────────────

async def iniciar_venta(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    init_venta(ctx)
    await update.message.reply_text(
        "📦 *Nueva Venta*\n\n"
        "¿El cliente tiene cuenta registrada?\n"
        "Escribe su *nombre o teléfono* para buscarlo,\n"
        "o escribe *GENERAL* para venta sin cliente.",
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(
            [["GENERAL"], ["❌ Cancelar"]], resize_keyboard=True
        )
    )
    return VENTA_CLIENTE


async def venta_cliente(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    texto   = update.message.text.strip()
    usuario = usuario_actual(ctx)

    if texto == "❌ Cancelar":
        await update.message.reply_text("❌ Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1  # MENU_PRINCIPAL

    if texto.upper() == "GENERAL":
        venta_actual(ctx)["cliente_nombre"] = "General"
        venta_actual(ctx)["cliente_id"]     = None
    else:
        clientes = db.buscar_cliente(texto)
        if clientes:
            c = clientes[0]
            venta_actual(ctx)["cliente_id"]     = c["id"]
            venta_actual(ctx)["cliente_nombre"] = f"{c['nombre']} {c.get('apellidos','')}"

            # Mostrar últimas 2 compras
            historial = db.ultimas_compras(c["id"])
            msg = f"✅ Cliente: *{venta_actual(ctx)['cliente_nombre']}*\n\n"
            if historial:
                msg += "📋 *Últimas compras:*\n"
                for h in historial:
                    fecha = h.get("fecha", "")[:10]
                    msg += f"  • {fecha} — {q(h.get('total',0))} — {h.get('productos','')}\n"
            else:
                msg += "_Sin compras anteriores_\n"
            await update.message.reply_text(msg, parse_mode="Markdown")
        else:
            venta_actual(ctx)["cliente_nombre"] = "General"
            venta_actual(ctx)["cliente_id"]     = None
            await update.message.reply_text("ℹ️ Cliente no encontrado. Se registrará como venta general.")

    await update.message.reply_text(
        "Escribe el *nombre o código de barra* del producto:",
        parse_mode="Markdown",
        reply_markup=teclado_cancelar()
    )
    return VENTA_PRODUCTO


# ── PASO 2: Buscar producto ───────────────────────────────────

async def venta_buscar_producto(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    texto   = update.message.text.strip()
    usuario = usuario_actual(ctx)

    if texto == "❌ Cancelar":
        await update.message.reply_text("❌ Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1

    productos = db.buscar_producto(texto)
    if not productos:
        await update.message.reply_text("❌ Producto no encontrado. Intenta con otro nombre:")
        return VENTA_PRODUCTO

    ctx.user_data["productos_encontrados"] = productos
    kb = [[f"{p['nombre']} — {q(p['precio_venta'])}"] for p in productos]
    kb.append(["❌ Cancelar"])

    await update.message.reply_text(
        "Selecciona el producto:",
        reply_markup=ReplyKeyboardMarkup(kb, resize_keyboard=True)
    )
    return VENTA_TALLA


# ── PASO 3: Seleccionar talla/color ──────────────────────────

async def venta_seleccionar_producto(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    texto    = update.message.text.strip()
    usuario  = usuario_actual(ctx)
    productos = ctx.user_data.get("productos_encontrados", [])

    if texto == "❌ Cancelar":
        await update.message.reply_text("❌ Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1

    if texto == "✅ Terminar venta":
        if not venta_actual(ctx)["items"]:
            await update.message.reply_text("⚠️ Agrega al menos un producto.")
            return VENTA_TALLA
        return await pedir_pago(update, ctx)

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
        talla = v.get("tallas", {}).get("nombre", "?") if v.get("tallas") else "?"
        color = v.get("colores", {}).get("nombre", "") if v.get("colores") else ""
        label = f"T:{talla}"
        if color:
            label += f" {color}"
        label += f" (stock: {v['stock']})"
        kb.append([label])
    kb.append(["❌ Cancelar"])

    await update.message.reply_text(
        f"*{producto['nombre']}* — {q(producto['precio_venta'])}\n"
        f"Selecciona la talla:",
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(kb, resize_keyboard=True)
    )
    return VENTA_CANTIDAD


# ── PASO 4: Cantidad ──────────────────────────────────────────

async def venta_seleccionar_talla(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    texto     = update.message.text.strip()
    usuario   = usuario_actual(ctx)
    variantes = ctx.user_data.get("variantes_disponibles", [])

    if texto == "❌ Cancelar":
        await update.message.reply_text("❌ Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1

    variante = None
    for v in variantes:
        talla = v.get("tallas", {}).get("nombre", "?") if v.get("tallas") else "?"
        color = v.get("colores", {}).get("nombre", "") if v.get("colores") else ""
        if talla in texto:
            if not color or color in texto:
                variante = v
                break

    if not variante:
        await update.message.reply_text("Selecciona una talla de la lista.")
        return VENTA_CANTIDAD

    ctx.user_data["variante_actual"] = variante
    await update.message.reply_text(
        f"¿Cuántas unidades? (disponibles: {variante['stock']})",
        reply_markup=ReplyKeyboardMarkup(
            [["1", "2", "3"], ["4", "5", "10"], ["❌ Cancelar"]],
            resize_keyboard=True
        )
    )
    return VENTA_MAS_PRODUCTOS


async def venta_cantidad(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    texto    = update.message.text.strip()
    usuario  = usuario_actual(ctx)
    variante = ctx.user_data.get("variante_actual", {})
    producto = ctx.user_data.get("producto_actual", {})

    if texto == "❌ Cancelar":
        await update.message.reply_text("❌ Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1

    try:
        cantidad = int(texto)
    except ValueError:
        await update.message.reply_text("Escribe un número válido.")
        return VENTA_MAS_PRODUCTOS

    if cantidad <= 0:
        await update.message.reply_text("La cantidad debe ser mayor a 0.")
        return VENTA_MAS_PRODUCTOS

    if cantidad > variante.get("stock", 0):
        await update.message.reply_text(
            f"⚠️ Solo hay {variante['stock']} unidades disponibles."
        )
        return VENTA_MAS_PRODUCTOS

    talla = variante.get("tallas", {}).get("nombre", "?") if variante.get("tallas") else "?"
    color = variante.get("colores", {}).get("nombre", "") if variante.get("colores") else ""
    precio = float(producto.get("precio_venta", 0))

    item = {
        "variante_id":    variante["id"],
        "nombre":         producto["nombre"],
        "talla":          talla,
        "color":          color,
        "cantidad":       cantidad,
        "precio_unitario": precio,
        "subtotal":       cantidad * precio
    }
    venta_actual(ctx)["items"].append(item)

    # Mostrar carrito
    items = venta_actual(ctx)["items"]
    total = sum(i["subtotal"] for i in items)
    resumen = "🛒 *Carrito:*\n"
    for it in items:
        c = f" {it['color']}" if it.get("color") else ""
        resumen += f"  • {it['nombre']} T:{it['talla']}{c} x{it['cantidad']} = {q(it['subtotal'])}\n"
    resumen += f"\n*Subtotal: {q(total)}*"

    await update.message.reply_text(
        resumen + "\n\n¿Agregar otro producto o terminar?",
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(
            [["📦 Agregar otro producto", "✅ Terminar venta"], ["❌ Cancelar"]],
            resize_keyboard=True
        )
    )
    return VENTA_METODO_PAGO


# ── PASO 5: Pago ──────────────────────────────────────────────

async def venta_decision(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    """Decisión: agregar más productos o ir al pago."""
    texto   = update.message.text.strip()
    usuario = usuario_actual(ctx)

    if texto == "❌ Cancelar":
        await update.message.reply_text("❌ Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1

    if texto == "📦 Agregar otro producto":
        await update.message.reply_text(
            "Escribe el nombre o código del siguiente producto:",
            reply_markup=teclado_cancelar()
        )
        return VENTA_PRODUCTO

    if texto == "✅ Terminar venta":
        return await pedir_pago(update, ctx)

    return VENTA_METODO_PAGO


async def pedir_pago(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    """Pide el método de pago."""
    items  = venta_actual(ctx)["items"]
    pagos  = venta_actual(ctx)["pagos"]
    total  = sum(i["subtotal"] for i in items)
    pagado = sum(p["monto"] for p in pagos)
    pendiente = total - pagado

    if pendiente <= 0.01:
        return await confirmar_venta(update, ctx)

    metodos = db.obtener_metodos_pago()
    ctx.user_data["metodos_pago"] = metodos
    kb = [[m["nombre"].capitalize()] for m in metodos]
    kb.append(["❌ Cancelar"])

    msg = f"💳 *Total: {q(total)}*\n"
    if pagado > 0:
        msg += f"Registrado: {q(pagado)}\n"
        msg += f"*Pendiente: {q(pendiente)}*\n"
    msg += "\n¿Método de pago?"

    await update.message.reply_text(
        msg,
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(kb, resize_keyboard=True)
    )
    return VENTA_MONTO_PAGO


async def venta_metodo(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    """Selección de método de pago."""
    texto    = update.message.text.strip().lower()
    usuario  = usuario_actual(ctx)
    metodos  = ctx.user_data.get("metodos_pago", [])

    if texto == "❌ cancelar":
        await update.message.reply_text("❌ Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1

    metodo = next((m for m in metodos if m["nombre"].lower() == texto), None)
    if not metodo:
        await update.message.reply_text("Selecciona un método de pago de la lista.")
        return VENTA_MONTO_PAGO

    ctx.user_data["metodo_actual"] = metodo
    items  = venta_actual(ctx)["items"]
    pagos  = venta_actual(ctx)["pagos"]
    total  = sum(i["subtotal"] for i in items)
    pagado = sum(p["monto"] for p in pagos)
    pendiente = total - pagado

    await update.message.reply_text(
        f"Monto en *{metodo['nombre'].capitalize()}*:\n"
        f"(Pendiente: {q(pendiente)})\n\n"
        f"Escribe el monto:",
        parse_mode="Markdown",
        reply_markup=teclado_cancelar()
    )
    return VENTA_CONFIRMAR


async def venta_monto(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    """Registra el monto del pago."""
    texto   = update.message.text.strip()
    usuario = usuario_actual(ctx)
    metodo  = ctx.user_data.get("metodo_actual", {})

    if texto == "❌ Cancelar":
        await update.message.reply_text("❌ Cancelado.", reply_markup=teclado_menu(usuario["rol"]))
        return 1

    try:
        monto = float(texto.replace(",", "").replace("Q", "").strip())
    except ValueError:
        await update.message.reply_text("Escribe un monto válido. Ejemplo: 150 o 1500.50")
        return VENTA_CONFIRMAR

    venta_actual(ctx)["pagos"].append({
        "metodo_id": metodo["id"],
        "nombre":    metodo["nombre"],
        "monto":     monto,
        "banco":     metodo.get("banco")
    })

    items  = venta_actual(ctx)["items"]
    pagos  = venta_actual(ctx)["pagos"]
    total  = sum(i["subtotal"] for i in items)
    pagado = sum(p["monto"] for p in pagos)
    pendiente = total - pagado

    if pendiente > 0.01:
        # Aún falta pago — pedir otro método
        metodos = db.obtener_metodos_pago()
        ctx.user_data["metodos_pago"] = metodos
        kb = [[m["nombre"].capitalize()] for m in metodos]
        kb.append(["❌ Cancelar"])
        await update.message.reply_text(
            f"✅ {metodo['nombre'].capitalize()}: {q(monto)} registrado.\n"
            f"*Pendiente: {q(pendiente)}*\n\n¿Otro método de pago?",
            parse_mode="Markdown",
            reply_markup=ReplyKeyboardMarkup(kb, resize_keyboard=True)
        )
        return VENTA_MONTO_PAGO

    return await confirmar_venta(update, ctx)


# ── PASO 6: Confirmar y guardar ───────────────────────────────

async def confirmar_venta(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    """Muestra resumen y pide confirmación."""
    venta   = venta_actual(ctx)
    resumen = formato_venta_resumen(
        venta["items"], venta["pagos"], venta["cliente_nombre"]
    )
    await update.message.reply_text(
        resumen + "\n¿Confirmar venta?",
        parse_mode="Markdown",
        reply_markup=ReplyKeyboardMarkup(
            [["✅ CONFIRMAR", "❌ CANCELAR"]],
            resize_keyboard=True
        )
    )
    return VENTA_CONFIRMAR


async def guardar_venta(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    """Guarda la venta en Supabase."""
    texto   = update.message.text.strip()
    usuario = usuario_actual(ctx)
    venta   = venta_actual(ctx)

    if texto == "❌ CANCELAR":
        init_venta(ctx)
        await update.message.reply_text(
            "❌ Venta cancelada.",
            reply_markup=teclado_menu(usuario["rol"])
        )
        return 1

    if texto != "✅ CONFIRMAR":
        return VENTA_CONFIRMAR

    venta_id = db.registrar_venta(
        usuario_id   = usuario["id"],
        cliente_id   = venta.get("cliente_id"),
        items        = venta["items"],
        pagos        = venta["pagos"],
        turno        = turno_actual()
    )

    if venta_id:
        total = sum(i["subtotal"] for i in venta["items"])
        await update.message.reply_text(
            f"✅ *¡Venta registrada!*\n\n"
            f"Total: *{q(total)}*\n"
            f"Vendedor: {usuario['nombre']}\n"
            f"Hora: {hora_actual()}",
            parse_mode="Markdown",
            reply_markup=teclado_menu(usuario["rol"])
        )
        logger.info(f"Venta {venta_id} guardada por {usuario['nombre']}")
    else:
        await update.message.reply_text(
            "❌ Error al guardar la venta. Contacta al administrador.",
            reply_markup=teclado_menu(usuario["rol"])
        )

    init_venta(ctx)
    return 1
