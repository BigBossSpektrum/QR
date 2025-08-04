# Configuración adicional para optimización en producción

# Configuraciones de caché (agregar a settings.py si es necesario)
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
