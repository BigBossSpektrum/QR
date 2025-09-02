# 🚀 Configuración de Deploy para Clever Cloud
# Credenciales reales de la base de datos PostgreSQL

## 📊 Variables de Entorno para Clever Cloud:

```bash
# Configurar en Clever Cloud CLI:

clever env set POSTGRESQL_ADDON_DB "bihckcsbxtpycru7fzc3"
clever env set POSTGRESQL_ADDON_HOST "bihckcsbxtpycru7fzc3-postgresql.services.clever-cloud.com"
clever env set POSTGRESQL_ADDON_PASSWORD "XpZCCVNaceAKNvn0wK3GgdqTpK3A7o"
clever env set POSTGRESQL_ADDON_PORT "5432"
clever env set POSTGRESQL_ADDON_URI "postgresql://uv24d06xzigvcazpqhub:XpZCCVNaceAKNvn0wK3GgdqTpK3A7o@bihckcsbxtpycru7fzc3-postgresql.services.clever-cloud.com:5432/bihckcsbxtpycru7fzc3"
clever env set POSTGRESQL_ADDON_USER "uv24d06xzigvcazpqhub"
clever env set POSTGRESQL_ADDON_VERSION "15"

# Configuración Django
clever env set SECRET_KEY "django-insecure-GENERA-UNA-NUEVA-CLAVE-SECRETA"
clever env set DEBUG "False"
clever env set DJANGO_SETTINGS_MODULE "qr_site.clever_cloud_settings"
clever env set ALLOWED_HOSTS "*.cleverapps.io,localhost,127.0.0.1"

# CORS para GitHub Pages
clever env set CORS_ALLOWED_ORIGINS "https://bigbossspektrum.github.io"
```

## 🔐 Generar SECRET_KEY nueva:

```python
# Ejecutar en terminal Python:
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
```

## 📋 Comando de Deploy:

```bash
# Después de configurar variables:
clever deploy
```

## 🔗 URL de tu aplicación:
Después del deploy, tu aplicación estará disponible en:
```
https://app-[tu-id].cleverapps.io
```

## ✅ Testing del Backend:
Cuando esté deployed, puedes probar:
- Admin: `https://app-[tu-id].cleverapps.io/admin`
- API: `https://app-[tu-id].cleverapps.io/api/qr/crear/`

## 🌐 Configurar Frontend:
Una vez que tengas la URL del backend, actualiza el frontend de GitHub Pages:
1. Ve a: https://bigbossspektrum.github.io/QR
2. En "Modo Redirección", configura tu URL de Clever Cloud
3. ¡Listo para usar ambos modos!

---
**⚠️ IMPORTANTE**: Guarda estas credenciales de forma segura. No las compartas públicamente.
