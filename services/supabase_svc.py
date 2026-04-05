"""
BARATELY Bot v2 — services/supabase_svc.py
Todas las operaciones con la base de datos.
"""
from config.database import get_db
from config.settings import logger
from datetime import datetime


def buscar_usuario_por_key(key: str) -> dict | None:
    try:
        db = get_db()
        res = db.table("usuarios")\
            .select("id, nombre, apellidos, rol_id, activo")\
            .eq("telegram_key", key.strip())\
            .execute()
        if res.data:
            u = res.data[0]
            if not u.get("activo"):
                return None
            rol_res = db.table("roles")\
                .select("nombre")\
                .eq("id", u["rol_id"])\
                .execute()
            u["rol"] = rol_res.data[0]["nombre"] if rol_res.data else "vendedor"
            return u
        return None
    except Exception as e:
        logger.error(f"buscar_usuario_por_key: {e}")
        return None


def buscar_usuario_por_chat(chat_id: int) -> dict | None:
    try:
        db = get_db()
        res = db.table("usuarios")\
            .select("id, nombre, apellidos, rol_id, activo")\
            .eq("telegram_chat_id", str(chat_id))\
            .execute()
        if res.data:
            u = res.data[0]
            if not u.get("activo"):
                return None
            rol_res = db.table("roles")\
                .select("nombre")\
                .eq("id", u["rol_id"])\
                .execute()
            u["rol"] = rol_res.data[0]["nombre"] if rol_res.data else "vendedor"
            return u
        return None
    except Exception as e:
        logger.error(f"buscar_usuario_por_chat: {e}")
        return None


def vincular_chat_id(usuario_id: str, chat_id: int) -> bool:
    try:
        db = get_db()
        db.table("usuarios").update({
            "telegram_chat_id": str(chat_id),
            "ultimo_acceso": datetime.now().isoformat()
        }).eq("id", usuario_id).execute()
        return True
    except Exception as e:
        logger.error(f"vincular_chat_id: {e}")
        return False


def desvincular_chat_id(usuario_id: str) -> bool:
    try:
        db = get_db()
        db.table("sesiones_bot").update({
            "estado": "cerrada"
        }).eq("usuario_id", usuario_id).eq("estado", "activa").execute()
        return True
    except Exception as e:
        logger.error(f"desvincular_chat_id: {e}")
        return False


def crear_sesion(usuario_id: str) -> bool:
    try:
        db = get_db()
        db.table("sesiones_bot").insert({
            "usuario_id": usuario_id,
            "canal": "telegram",
            "estado": "activa"
        }).execute()
        return True
    except Exception as e:
        logger.error(f"crear_sesion: {e}")
        return False


def buscar_cliente(texto: str) -> list:
    try:
        db = get_db()
        res = db.table("clientes")\
            .select("id, nombre, apellidos, telefono, whatsapp")\
            .or_(f"nombre.ilike.%{texto}%,telefono.ilike.%{texto}%")\
            .eq("activo", True)\
            .limit(5)\
            .execute()
        return res.data or []
    except Exception as e:
        logger.error(f"buscar_cliente: {e}")
        return []


def ultimas_compras(cliente_id: str) -> list:
    try:
        db = get_db()
        res = db.rpc("ultimas_compras_cliente", {
            "p_cliente_id": cliente_id
        }).execute()
        return res.data or []
    except Exception as e:
        logger.error(f"ultimas_compras: {e}")
        return []


def buscar_producto(texto: str) -> list:
    try:
        db = get_db()
        res = db.table("productos")\
            .select("id, nombre, codigo_barra, tipo_ropa, precio_venta")\
            .or_(f"nombre.ilike.%{texto}%,codigo_barra.ilike.%{texto}%")\
            .eq("activo", True)\
            .limit(5)\
            .execute()
        return res.data or []
    except Exception as e:
        logger.error(f"buscar_producto: {e}")
        return []


def obtener_variantes(producto_id: str) -> list:
    try:
        db = get_db()
        res = db.table("variantes")\
            .select("id, stock, stock_minimo, tallas(nombre, grupo), colores(nombre, hex)")\
            .eq("producto_id", producto_id)\
            .eq("activo", True)\
            .gt("stock", 0)\
            .execute()
        return res.data or []
    except Exception as e:
        logger.error(f"obtener_variantes: {e}")
        return []


def stock_bajo() -> list:
    try:
        db = get_db()
        res = db.table("vw_stock_bajo").select("*").limit(10).execute()
        return res.data or []
    except Exception as e:
        logger.error(f"stock_bajo: {e}")
        return []


def registrar_venta(usuario_id: str, cliente_id,
                    items: list, pagos: list, turno: str):
    try:
        db = get_db()
        total = sum(i["subtotal"] for i in items)
        res = db.table("ventas").insert({
            "usuario_id": usuario_id,
            "cliente_id": cliente_id,
            "total": total,
            "turno": turno,
            "estado": "completada"
        }).execute()
        venta_id = res.data[0]["id"]
        for item in items:
            db.table("detalle_venta").insert({
                "venta_id": venta_id,
                "variante_id": item["variante_id"],
                "cantidad": item["cantidad"],
                "precio_unitario": item["precio_unitario"]
            }).execute()
        for pago in pagos:
            db.table("pagos_venta").insert({
                "venta_id": venta_id,
                "metodo_pago_id": pago["metodo_id"],
                "monto": pago["monto"],
                "banco": pago.get("banco")
            }).execute()
        logger.info(f"Venta registrada: {venta_id} — Total: Q{total}")
        return venta_id
    except Exception as e:
        logger.error(f"registrar_venta: {e}")
        return None


def ventas_del_dia(usuario_id: str) -> list:
    try:
        db = get_db()
        hoy   = datetime.now().date().isoformat()
        inicio = f"{hoy}T00:00:00"
        fin    = f"{hoy}T23:59:59"
        res = db.table("ventas")\
            .select("id, total, fecha, turno, estado")\
            .eq("usuario_id", usuario_id)\
            .gte("fecha", inicio)\
            .lte("fecha", fin)\
            .eq("estado", "completada")\
            .order("fecha", desc=True)\
            .execute()
        return res.data or []
    except Exception as e:
        logger.error(f"ventas_del_dia: {e}")
        return []


def obtener_metodos_pago() -> list:
    try:
        db = get_db()
        res = db.table("metodos_pago")\
            .select("id, nombre, banco")\
            .eq("activo", True)\
            .execute()
        return res.data or []
    except Exception as e:
        logger.error(f"obtener_metodos_pago: {e}")
        return []


def solicitar_vale(usuario_id: str, monto: float, motivo: str) -> bool:
    try:
        db = get_db()
        db.table("vales").insert({
            "usuario_id": usuario_id,
            "monto": monto,
            "motivo": motivo,
            "estado": "pendiente"
        }).execute()
        return True
    except Exception as e:
        logger.error(f"solicitar_vale: {e}")
        return False


def vales_pendientes(usuario_id: str = None) -> list:
    try:
        db = get_db()
        q = db.table("vales")\
            .select("id, monto, motivo, estado, fecha, usuarios(nombre)")\
            .eq("estado", "pendiente")
        if usuario_id:
            q = q.eq("usuario_id", usuario_id)
        res = q.order("fecha", desc=True).limit(10).execute()
        return res.data or []
    except Exception as e:
        logger.error(f"vales_pendientes: {e}")
        return []


def resumen_dia() -> list:
    try:
        db_client = get_db()
        hoy    = datetime.now().date().isoformat()
        inicio = f"{hoy}T00:00:00"
        fin    = f"{hoy}T23:59:59"

        # Ventas completadas hoy, agrupadas por vendedor
        res = db_client.table("ventas")\
            .select("id, total, usuario_id, turno, usuarios(nombre)")\
            .gte("fecha", inicio)\
            .lte("fecha", fin)\
            .eq("estado", "completada")\
            .execute()

        resumen = {}
        for v in (res.data or []):
            uid    = v["usuario_id"]
            nombre = (v.get("usuarios") or {}).get("nombre", "?")
            if uid not in resumen:
                resumen[uid] = {
                    "vendedor":      nombre,
                    "total_vendido": 0.0,
                    "num_ventas":    0,
                    "vales_del_dia": 0.0,
                }
            resumen[uid]["total_vendido"] += float(v.get("total") or 0)
            resumen[uid]["num_ventas"]    += 1

        # Vales aprobados hoy (ignorar si la tabla no existe)
        try:
            vales_res = db_client.table("vales")\
                .select("usuario_id, monto, usuarios(nombre)")\
                .gte("fecha", inicio)\
                .lte("fecha", fin)\
                .eq("estado", "aprobado")\
                .execute()
            for vale in (vales_res.data or []):
                uid    = vale["usuario_id"]
                nombre = (vale.get("usuarios") or {}).get("nombre", "?")
                if uid not in resumen:
                    resumen[uid] = {
                        "vendedor":      nombre,
                        "total_vendido": 0.0,
                        "num_ventas":    0,
                        "vales_del_dia": 0.0,
                    }
                resumen[uid]["vales_del_dia"] += float(vale.get("monto") or 0)
        except Exception as ev:
            logger.warning(f"resumen_dia (vales): {ev}")

        return list(resumen.values())
    except Exception as e:
        logger.error(f"resumen_dia: {e}")
        return []


def alertas_pendientes(limite: int = 5) -> list:
    try:
        db = get_db()
        res = db.table("alertas_ia")\
            .select("tipo, prioridad, titulo, mensaje")\
            .eq("resuelta", False)\
            .order("creado_en", desc=True)\
            .limit(limite)\
            .execute()
        return res.data or []
    except Exception as e:
        logger.error(f"alertas_pendientes: {e}")
        return []
