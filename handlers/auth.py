"""
BARATELY Bot v2 — handlers/auth.py
Login, logout y verificacion de sesion.
"""
from telegram import Update
from telegram.ext import ContextTypes, ConversationHandler
from services.supabase_svc import (
    buscar_usuario_por_chat, buscar_usuario_por_key,
    vincular_chat_id, crear_sesion, desvincular_chat_id
)
from services.mensajes import (
    teclado_menu, texto_menu, sin_teclado, MSG_BIENVENIDA,
    fecha_hoy, hora_actual, turno_actual
)
from config.settings import logger

# Estados
ESPERANDO_KEY  = 0
MENU_PRINCIPAL = 1


async def cmd_start(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    chat_id = update.effective_chat.id
    usuario = buscar_usuario_por_chat(chat_id)

    if usuario:
        ctx.user_data["usuario"] = usuario
        await update.message.reply_text(
            f"👋 *{usuario['nombre']}*, bienvenido de nuevo.\n"
            f"📅 {fecha_hoy()}  🕐 {hora_actual()}\n\n"
            + texto_menu(usuario["rol"]),
            parse_mode="Markdown",
            reply_markup=teclado_menu(usuario["rol"])
        )
        logger.info(f"Sesion existente: {usuario['nombre']} (chat {chat_id})")
        return MENU_PRINCIPAL

    await update.message.reply_text(
        MSG_BIENVENIDA,
        parse_mode="Markdown",
        reply_markup=sin_teclado()
    )
    return ESPERANDO_KEY


async def recibir_key(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    key     = update.message.text.strip()
    chat_id = update.effective_chat.id

    if key.startswith("/"):
        await update.message.reply_text("Primero ingresa tu clave personal.")
        return ESPERANDO_KEY

    usuario = buscar_usuario_por_key(key)

    if not usuario:
        logger.warning(f"Clave incorrecta desde chat {chat_id}: '{key}'")
        await update.message.reply_text(
            "Clave incorrecta.\n"
            "Verifica tu clave e intenta de nuevo.\n"
            "Si no la recuerdas contacta al administrador."
        )
        return ESPERANDO_KEY

    vincular_chat_id(usuario["id"], chat_id)
    crear_sesion(usuario["id"])
    ctx.user_data["usuario"] = usuario

    logger.info(f"Login exitoso: {usuario['nombre']} (chat {chat_id})")

    turno  = turno_actual()
    iconos = {"manana": "🌅", "tarde": "🌤", "noche": "🌙"}
    await update.message.reply_text(
        f"✅ *¡Acceso concedido!*\n\n"
        f"{iconos.get(turno,'👋')} Hola, *{usuario['nombre']}*\n"
        f"Rol: {usuario['rol'].capitalize()}\n"
        f"📅 {fecha_hoy()}  🕐 {hora_actual()}\n\n"
        + texto_menu(usuario["rol"]),
        parse_mode="Markdown",
        reply_markup=teclado_menu(usuario["rol"])
    )
    return MENU_PRINCIPAL


async def mostrar_menu(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    usuario = usuario_actual(ctx)
    if not usuario:
        return await cmd_start(update, ctx)
    await update.message.reply_text(
        texto_menu(usuario["rol"]),
        parse_mode="Markdown",
        reply_markup=teclado_menu(usuario["rol"])
    )
    return MENU_PRINCIPAL


async def cerrar_sesion(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    usuario = ctx.user_data.get("usuario")
    if usuario:
        desvincular_chat_id(usuario["id"])
        logger.info(f"Sesion cerrada: {usuario['nombre']}")
    ctx.user_data.clear()
    await update.message.reply_text(
        "Sesion cerrada. Hasta pronto!\n\n"
        "Escribe /start para volver a entrar.",
        reply_markup=sin_teclado()
    )
    return ConversationHandler.END


async def cancelar(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> int:
    usuario = ctx.user_data.get("usuario")
    if usuario:
        await update.message.reply_text(
            "Operacion cancelada.\n\n"
            + texto_menu(usuario["rol"]),
            parse_mode="Markdown",
            reply_markup=teclado_menu(usuario["rol"])
        )
        return MENU_PRINCIPAL
    return ConversationHandler.END


def usuario_actual(ctx: ContextTypes.DEFAULT_TYPE) -> dict | None:
    return ctx.user_data.get("usuario")


def tiene_permiso(usuario: dict, roles: list) -> bool:
    return usuario.get("rol") in roles


async def verificar_sesion(update: Update, ctx: ContextTypes.DEFAULT_TYPE) -> bool:
    """Verifica sesión activa. Devuelve True si válida, False y avisa si expiró."""
    if ctx.user_data.get("usuario"):
        return True
    await update.message.reply_text(
        "⏱ Tu sesión expiró o el bot fue reiniciado.\n"
        "Escribe /start para volver a entrar.",
        reply_markup=sin_teclado()
    )
    return False
