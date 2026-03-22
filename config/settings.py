"""
BARATELY Bot v2 — config/settings.py
Configuración central. Lee variables del .env
"""
import os
import logging
from dotenv import load_dotenv

load_dotenv()

# ── Telegram ──────────────────────────────────────────────────
TELEGRAM_TOKEN = os.getenv("TELEGRAM_TOKEN", "")

# ── Supabase ──────────────────────────────────────────────────
SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_KEY = os.getenv("SUPABASE_KEY", "")

# ── Debug ─────────────────────────────────────────────────────
DEBUG = os.getenv("DEBUG", "false").lower() == "true"

# ── Logging ───────────────────────────────────────────────────
LOG_LEVEL = logging.DEBUG if DEBUG else logging.INFO

logging.basicConfig(
    format="%(asctime)s [%(levelname)s] %(name)s — %(message)s",
    level=LOG_LEVEL,
    handlers=[
        logging.StreamHandler(),
    ]
)
logger = logging.getLogger("barately")

# ── Validación al arrancar ────────────────────────────────────
def validar_config():
    errores = []
    if not TELEGRAM_TOKEN:
        errores.append("TELEGRAM_TOKEN no configurado")
    if not SUPABASE_URL or "TU_SUPABASE" in SUPABASE_URL:
        errores.append("SUPABASE_URL no configurado")
    if not SUPABASE_KEY or "TU_SUPABASE" in SUPABASE_KEY:
        errores.append("SUPABASE_KEY no configurado")
    return errores

# ── Constantes de la app ──────────────────────────────────────
DURACION_SESION_HORAS = 8
PORCENTAJE_COMISION   = 5.0
MAX_ALERTAS_BOT       = 5
