# 🚀 Sistema QR Híbrido: Clever Cloud + GitHub Pages

## 📋 Resumen del Sistema

✅ **Sistema completamente configurado y listo para deploy**

### 🏗️ Arquitectura Híbrida
- **Backend**: Django en Clever Cloud (BD PostgreSQL)
- **Frontend**: Interfaz estática en GitHub Pages
- **Comunicación**: CORS configurado entre ambos dominios

### 🎯 Funcionalidades
1. **Modo Directo**: Genera QR codes instantáneos con QRCode.js
2. **Modo Redirección**: Usa backend Clever Cloud para tracking y gestión

---

## 🔧 Configuración Completada

### ✅ Base de Datos Clever Cloud
```
Host: bihckcsbxtpycru7fzc3-postgresql.services.clever-cloud.com
Puerto: 5432
BD: bihckcsbxtpycru7fzc3
Usuario: uv24d06xzigvcazpqhub
```

### ✅ Archivos Creados
- `qr_site/clever_cloud_settings.py` - Settings producción
- `qr_site/local_clever_settings.py` - Settings desarrollo
- `clevercloud/python.json` - Config deploy Clever Cloud
- `Procfile` - Comando inicio servidor
- `github-pages/index.html` - Frontend interface
- `requirements.txt` - Actualizado con CORS

### ✅ Dependencias Instaladas
- `django-cors-headers==4.3.1` - Para comunicación CORS
- Todas las migraciones aplicadas a BD Clever Cloud
- Superuser `admin` creado

---

## 🚀 Pasos para Deploy

### 1️⃣ Deploy a Clever Cloud

```bash
# Instalar Clever Cloud CLI
npm install -g clever-tools

# Login a Clever Cloud
clever login

# Navegar al directorio del proyecto
cd "c:\Users\Entrecables y Redes\Documents\GitHub\QR"

# Crear aplicación Python en Clever Cloud
clever create --type python --name "qr-system-backend" --alias qr-backend

# Agregar las variables de entorno necesarias
clever env set SECRET_KEY "tu-secret-key-segura-aqui"
clever env set DEBUG "False"
clever env set ALLOWED_HOSTS "app-your-id.cleverapps.io,localhost,127.0.0.1"

# Verificar variables de BD (ya deberían estar configuradas)
clever env list

# Deploy
clever deploy
```

### 2️⃣ Deploy a GitHub Pages

```bash
# Crear rama gh-pages
git checkout -b gh-pages

# Copiar frontend a root
cp github-pages/* .

# Actualizar URL del backend en index.html
# Cambiar: http://127.0.0.1:8000
# Por: https://app-your-id.cleverapps.io

# Commit y push
git add .
git commit -m "🌐 Frontend GitHub Pages para QR System"
git push origin gh-pages

# Activar GitHub Pages desde Settings del repo
```

### 3️⃣ Configurar GitHub Pages

1. Ve a tu repositorio en GitHub
2. Settings → Pages
3. Source: Deploy from branch
4. Branch: `gh-pages` 
5. Folder: `/ (root)`
6. Save

---

## 🔗 URLs Finales

### Después del deploy tendrás:
- **Frontend**: `https://tu-usuario.github.io/QR`
- **Backend API**: `https://app-your-id.cleverapps.io`
- **Admin Panel**: `https://app-your-id.cleverapps.io/admin`

---

## 🧪 Testing Local

### Para probar antes del deploy:

```bash
# Usar configuración local con BD Clever Cloud
python manage.py runserver --settings=qr_site.local_clever_settings

# Abrir en navegador
# http://127.0.0.1:8000 - Interfaz completa
# http://127.0.0.1:8000/admin - Panel admin
```

---

## 📱 Como Usar el Sistema

### 🔄 Modo Directo (GitHub Pages)
1. Ir a `https://tu-usuario.github.io/QR`
2. Seleccionar "Modo Directo"
3. Ingresar URL
4. QR se genera instantáneamente (solo client-side)

### 🔄 Modo Redirección (Clever Cloud)
1. En la misma página, seleccionar "Modo Redirección"
2. Ingresar URL y título
3. Se crea en BD Clever Cloud
4. QR redirige via `https://app-your-id.cleverapps.io/qr/CODIGO`

---

## 🛠️ Gestión y Mantenimiento

### Panel de Administración
- URL: `https://app-your-id.cleverapps.io/admin`
- Usuario: `admin`
- Password: (el que configuraste)

### Funcionalidades Admin:
- ✅ Crear/editar códigos QR
- ✅ Habilitar/deshabilitar códigos
- ✅ Ver estadísticas de uso
- ✅ Gestionar usuarios

### API Endpoints:
- `GET /api/qr/crear/` - Crear QR code
- `GET /qr/{codigo}/` - Redireccionar QR
- `GET /qr/{codigo}/toggle/` - Habilitar/deshabilitar

---

## 🔍 Solución de Problemas

### ❌ Error CORS
- Verificar `CORS_ALLOWED_ORIGINS` en settings
- Asegurar que GitHub Pages URL esté incluida

### ❌ BD Connection Error
- Verificar credenciales Clever Cloud
- Comprobar variables de entorno

### ❌ Static Files Issues
- Ejecutar `python manage.py collectstatic`
- Verificar configuración WhiteNoise

---

## 📊 Logs y Monitoring

### Clever Cloud Logs:
```bash
# Ver logs en tiempo real
clever logs

# Ver logs específicos
clever logs --before="2025-01-02 10:00"
```

### GitHub Pages:
- No requiere monitoring especial
- Static files served by GitHub

---

## 🎉 ¡Sistema Listo!

Tu sistema QR híbrido está completamente configurado y listo para usar. La combinación de:

- **GitHub Pages** (frontend estático, rápido, gratuito)
- **Clever Cloud** (backend Django, BD PostgreSQL, tracking)

Te da lo mejor de ambos mundos: velocidad para uso básico y funcionalidad completa para gestión avanzada.

### 💡 Ventajas del Sistema:
- ⚡ Generación instantánea de QR (modo directo)
- 📊 Tracking y analytics (modo redirección)
- 🔒 Gestión administrativa completa
- 💰 Costo mínimo (GitHub Pages gratis + Clever Cloud tier básico)
- 🚀 Alta disponibilidad y performance

---

**¡Feliz deployment! 🎊**
