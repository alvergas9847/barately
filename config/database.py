"""
BARATELY Bot v2 — config/database.py
Conexión única a Supabase con verificación de salud
"""
from supabase import create_client
from supabase.client import Client
from config.settings import SUPABASE_URL, SUPABASE_KEY, logger


_cliente: Client = None


def get_db() -> Client:
    """Retorna el cliente Supabase. Lo crea si no existe."""
    global _cliente
    if _cliente is None:
        logger.info("Conectando a Supabase...")
        _cliente = create_client(SUPABASE_URL, SUPABASE_KEY)
        logger.info("Conexión a Supabase establecida")
    return _cliente


def verificar_conexion() -> bool:
    """Verifica que la conexión a Supabase funcione correctamente."""
    try:
        db = get_db()
        res = db.table("usuarios").select("id").limit(1).execute()
        logger.info("Verificación de Supabase: OK")
        return True
    except Exception as e:
        logger.error(f"Error de conexión a Supabase: {e}")
        return False
