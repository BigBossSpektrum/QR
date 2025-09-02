# Configuración local para testing con Clever Cloud DB
import os
from qr_site.clever_cloud_settings import *

# Override para desarrollo local
DEBUG = True

ALLOWED_HOSTS = ['localhost', '127.0.0.1', '*']

# Desactivar HTTPS para desarrollo local
SECURE_SSL_REDIRECT = False
SESSION_COOKIE_SECURE = False
CSRF_COOKIE_SECURE = False

# Configuración de CORS más permisiva para desarrollo
CORS_ALLOW_ALL_ORIGINS = True

# Logging más detallado
LOGGING['loggers']['django']['level'] = 'DEBUG'

print("🔧 Configuración local cargada")
print(f"📊 Base de datos: {DATABASES['default']['HOST']}:{DATABASES['default']['PORT']}")
print(f"🗄️  DB Name: {DATABASES['default']['NAME']}")
print(f"👤 User: {DATABASES['default']['USER']}")
