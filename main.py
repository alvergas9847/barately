"""
BARATELY Bot v2 — main.py
Punto de entrada.
"""
import sys
from telegram.ext import (
    Application, CommandHandler, MessageHandler,
    ConversationHandler, filters
)
from config.settings import TELEGRAM_TOKEN, validar_config, logger
from config.database import verificar_conexion

from handlers.auth import (
    cmd_start, recibir_key, cerrar_sesion, cancelar, mostrar_menu,
    ESPERANDO_KEY, MENU_PRINCIPAL
)
from handlers.ventas import (
    iniciar_venta, venta_cliente, venta_buscar_producto,
    venta_seleccionar_producto, venta_seleccionar_talla,
    venta_cantidad, venta_decision, venta_metodo,
    venta_monto, guardar_venta,
    VENTA_CLIENTE, VENTA_PRODUCTO, VENTA_TALLA,
    VENTA_CANTIDAD, VENTA_MAS_PRODUCTOS,
    VENTA_METODO_PAGO, VENTA_MONTO_PAGO, VENTA_CONFIRMAR
)
from handlers.inventario import (
    iniciar_stock, buscar_stock, mis_ventas,
    resumen_dia, ver_alertas, iniciar_vale,
    vale_monto, vale_motivo,
    STOCK_BUSCAR, VALE_MONTO, VALE_MOTIVO
)
from services.mensajes import (
    BTN_VENTA, BTN_VENTAS, BTN_STOCK, BTN_VALE,
    BTN_RESUMEN, BTN_ALERTAS, BTN_SALIR
)


def construir_conversacion() -> ConversationHandler:
    TEXT = filters.TEXT & ~filters.COMMAND

    return ConversationHandler(
        entry_points=[CommandHandler("start", cmd_start)],
        states={
            ESPERANDO_KEY: [
                MessageHandler(TEXT, recibir_key)
            ],
            MENU_PRINCIPAL: [
                # Botones descriptivos (nuevo) + números (compatibilidad)
                MessageHandler(filters.Regex(f"^({BTN_VENTA}|1)$"),   iniciar_venta),
                MessageHandler(filters.Regex(f"^({BTN_VENTAS}|2)$"),  mis_ventas),
                MessageHandler(filters.Regex(f"^({BTN_STOCK}|3)$"),   iniciar_stock),
                MessageHandler(filters.Regex(f"^({BTN_VALE}|4)$"),    iniciar_vale),
                MessageHandler(filters.Regex(f"^({BTN_RESUMEN}|5)$"), resumen_dia),
                MessageHandler(filters.Regex(f"^({BTN_ALERTAS}|6)$"), ver_alertas),
                MessageHandler(filters.Regex(f"^({BTN_SALIR}|0)$"),   cerrar_sesion),
                MessageHandler(TEXT, mostrar_menu),
            ],
            VENTA_CLIENTE: [
                MessageHandler(TEXT, venta_cliente)
            ],
            VENTA_PRODUCTO: [
                MessageHandler(TEXT, venta_buscar_producto)
            ],
            VENTA_TALLA: [
                MessageHandler(TEXT, venta_seleccionar_producto)
            ],
            VENTA_CANTIDAD: [
                MessageHandler(TEXT, venta_seleccionar_talla)
            ],
            VENTA_MAS_PRODUCTOS: [
                MessageHandler(TEXT, venta_cantidad)
            ],
            VENTA_METODO_PAGO: [
                MessageHandler(TEXT, venta_decision)
            ],
            VENTA_MONTO_PAGO: [
                MessageHandler(TEXT, venta_metodo)
            ],
            VENTA_CONFIRMAR: [
                MessageHandler(filters.Regex("CONFIRMAR|CANCELAR"), guardar_venta),
                MessageHandler(TEXT, venta_monto),
            ],
            STOCK_BUSCAR: [
                MessageHandler(TEXT, buscar_stock)
            ],
            VALE_MONTO: [
                MessageHandler(TEXT, vale_monto)
            ],
            VALE_MOTIVO: [
                MessageHandler(TEXT, vale_motivo)
            ],
        },
        fallbacks=[
            CommandHandler("cancelar", cancelar),
            CommandHandler("start",    cmd_start),
        ],
        allow_reentry=True,
    )


def main():
    errores = validar_config()
    if errores:
        for e in errores:
            logger.error(f"CONFIG ERROR: {e}")
        sys.exit(1)

    logger.info("Verificando conexion a Supabase...")
    if not verificar_conexion():
        logger.error("No se pudo conectar a Supabase.")
        sys.exit(1)

    app = Application.builder().token(TELEGRAM_TOKEN).build()
    app.add_handler(construir_conversacion())

    logger.info("=" * 50)
    logger.info("  BARATELY Bot v2 - Iniciado correctamente")
    logger.info("=" * 50)

    app.run_polling(
        allowed_updates=["message", "callback_query"],
        drop_pending_updates=True
    )


if __name__ == "__main__":
    main()
