# Configuración para Render.com con PostgreSQL persistente
import os
import dj_database_url
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent

# IMPORTANTE: Base de datos PostgreSQL para persistencia
DATABASES = {
    'default': dj_database_url.config(
        default=os.environ.get('DATABASE_URL'),
        conn_max_age=600,
        conn_health_checks=True,
    )
}

# Configuraciones de seguridad para producción
DEBUG = False
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'

# CSRF y cookies seguras
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True
SECURE_SSL_REDIRECT = True

# Configuraciones de caché
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
        'LOCATION': 'unique-snowflake',
    }
}

# Configuraciones de sesión optimizadas
SESSION_ENGINE = 'django.contrib.sessions.backends.cached_db'
SESSION_CACHE_ALIAS = 'default'
SESSION_COOKIE_AGE = 1209600  # 2 semanas

# Configuraciones de archivos media (si se necesitan)
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

# Configuraciones de logging para producción
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'level': 'INFO',
        },
    },
}

# Configuraciones de email (para notificaciones de errores)
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
ADMINS = [('Admin', 'admin@chaos-qr-service.onrender.com')]
MANAGERS = ADMINS
