# 🚀 Sistema QR Híbrido - Documentación Completa

## 🏗️ Arquitectura del Sistema

El sistema QR utiliza una **arquitectura híbrida** que combina:

- **Frontend Estático** → GitHub Pages (HTML/CSS/JS)
- **Backend API** → Clever Cloud (Django + PostgreSQL)
- **Redirecciones** → Clever Cloud (manejo de QR escaneados)

## 🔄 Flujo de Funcionamiento

```
1. Usuario visita: https://bigbossspektrum.github.io/QR
2. Llena formulario (URL + descripción opcional)
3. JavaScript envía POST a: https://tu-app.cleverapps.io/backend/api/generar-qr/
4. Backend Django crea registro en PostgreSQL
5. Backend retorna QR en base64 + URL de redirección
6. Usuario descarga QR
7. Al escanear QR → Clever Cloud maneja redirección
```

## 📁 Estructura del Proyecto

```
qr_site/
├── 📱 FRONTEND (GitHub Pages)
│   ├── github-pages/          # Archivos estáticos generados
│   ├── templates/frontend/    # Templates Django para generar HTML
│   └── frontend/              # App Django del frontend
│
├── 🖥️ BACKEND (Clever Cloud)
│   ├── backend/               # App Django del backend (API)
│   ├── qr_site/              # Configuraciones Django
│   │   ├── clever_cloud_settings.py  # Settings para Clever Cloud
│   │   └── github_pages_settings.py  # Settings para GitHub Pages
│   └── requirements.txt       # Dependencias Python
│
├── 🚀 DEPLOY
│   ├── deploy-hibrido.sh      # Script principal de deploy
│   └── generate-github-pages.sh  # Generador de archivos estáticos
│
└── 📚 DOCS
    └── docs/                  # Documentación del proyecto
```

## 🛠️ Componentes Técnicos

### Frontend (GitHub Pages)
- **Tecnología**: HTML5 + CSS3 + JavaScript vanilla
- **Framework CSS**: Bootstrap 5
- **Iconos**: Font Awesome 6
- **Funcionalidades**:
  - Formulario para generar QR
  - Visualización del QR generado
  - Descarga de imagen QR
  - Validación de URLs en tiempo real

### Backend (Clever Cloud)
- **Framework**: Django 5.2.4
- **Base de Datos**: PostgreSQL
- **API Endpoints**:
  - `POST /backend/api/generar-qr/` - Genera nuevo QR
  - `GET /backend/qr/<uuid>/` - Redirección del QR escaneado
  - `GET /backend/api/mis-qr/` - Lista QRs del usuario
  - `DELETE /backend/api/eliminar-qr/<uuid>/` - Elimina QR
  - `POST /backend/api/toggle-qr/<uuid>/` - Activa/desactiva QR

### Modelo de Datos
```python
class CodigoQR(models.Model):
    codigo = UUIDField(unique=True)      # Identificador único
    contenido = TextField()              # URL original
    descripcion = CharField()            # Descripción opcional
    usuario = ForeignKey(User)           # Usuario que creó el QR
    creado = DateTimeField()            # Fecha de creación
    accesos = PositiveIntegerField()     # Contador de escaneos
    activo = BooleanField()             # Estado del QR
```

## 🔧 Configuración del Deploy

### 1. Variables de Entorno (Clever Cloud)

```bash
# Base de datos PostgreSQL
POSTGRESQL_ADDON_DB=tu_base_datos
POSTGRESQL_ADDON_HOST=host.services.clever-cloud.com
POSTGRESQL_ADDON_PASSWORD=tu_password
POSTGRESQL_ADDON_PORT=5432
POSTGRESQL_ADDON_URI=postgresql://...
POSTGRESQL_ADDON_USER=tu_usuario

# Django
SECRET_KEY=tu_secret_key_super_segura
DEBUG=False
DJANGO_SETTINGS_MODULE=qr_site.clever_cloud_settings
ALLOWED_HOSTS=tu-app.cleverapps.io,localhost

# CORS para GitHub Pages
CORS_ALLOWED_ORIGINS=https://bigbossspektrum.github.io
```

### 2. Configuración CORS

```python
# clever_cloud_settings.py
CORS_ALLOWED_ORIGINS = [
    "https://bigbossspektrum.github.io",
    "https://bigbossspektrum.github.io/QR",
]

CORS_ALLOWED_HEADERS = [
    'accept', 'content-type', 'origin', 'x-requested-with'
]
```

## 🚀 Instrucciones de Deploy

### Deploy Automático (Recomendado)
```bash
chmod +x deploy-hibrido.sh
./deploy-hibrido.sh
```

### Deploy Manual

#### 1. Backend a Clever Cloud
```bash
# Instalar Clever Cloud CLI
npm install -g clever-tools

# Login
clever login

# Configurar variables de entorno
clever env set SECRET_KEY "tu_secret_key"
clever env set DEBUG "False"
clever env set DJANGO_SETTINGS_MODULE "qr_site.clever_cloud_settings"

# Deploy
clever deploy
```

#### 2. Frontend a GitHub Pages
```bash
# Generar archivos estáticos
chmod +x generate-github-pages.sh
./generate-github-pages.sh

# Subir a GitHub
git add github-pages/
git commit -m "Deploy frontend estático"
git push origin main
```

#### 3. Activar GitHub Pages
1. Ve a **Settings** > **Pages** en tu repositorio
2. Selecciona **Deploy from a branch**
3. Elige **main branch**
4. Selecciona **/ (root)** folder
5. Guarda la configuración

## 🔍 Testing del Sistema

### 1. Test del Backend API
```bash
# Crear superusuario
clever run python manage.py createsuperuser

# Test de endpoint
curl -X POST https://tu-app.cleverapps.io/backend/api/generar-qr/ \
  -H "Content-Type: application/json" \
  -d '{"url":"https://google.com","descripcion":"Test QR"}'
```

### 2. Test del Frontend
1. Visita: `https://bigbossspektrum.github.io/QR`
2. Ingresa una URL: `https://example.com`
3. Añade descripción: `Mi primer QR`
4. Haz clic en **Generar QR**
5. Verifica que aparece el código QR
6. Descarga la imagen
7. Escanea el QR con tu móvil

### 3. Test de Redirección
1. Escanea el QR generado
2. Verifica que redirija a la URL original
3. Comprueba en el admin de Django que se incrementó el contador

## 🆘 Solución de Problemas

### Error de CORS
```javascript
// Console error: "Access to fetch at '...' from origin '...' has been blocked by CORS policy"
```
**Solución**: Verificar configuración CORS en `clever_cloud_settings.py`

### Error 404 en API
```javascript
// Error: Failed to fetch
```
**Solución**: Verificar que la URL del backend esté correcta en el frontend

### Error de Base de Datos
```python
# Error: FATAL: password authentication failed
```
**Solución**: Verificar variables de entorno PostgreSQL en Clever Cloud

### GitHub Pages no actualiza
**Solución**: 
1. Verificar que los archivos estén en la rama correcta
2. Esperar 2-5 minutos para propagación
3. Revisar configuración en Settings > Pages

## 📊 Monitoreo y Logs

### Logs de Clever Cloud
```bash
# Ver logs en tiempo real
clever logs

# Ver logs específicos
clever logs --before="2024-12-10" --after="2024-12-09"
```

### Estadísticas de QR
- **Admin Panel**: `https://tu-app.cleverapps.io/admin`
- **API Endpoint**: `GET /backend/api/mis-qr/`

## 🔐 Seguridad

### Medidas Implementadas
- ✅ CORS restringido a dominios específicos
- ✅ URLs validadas antes de crear QR
- ✅ HTTPS forzado en producción
- ✅ Secret Key segura
- ✅ Debug deshabilitado en producción

### Recomendaciones Adicionales
- 🔒 Implementar rate limiting
- 🔒 Añadir autenticación para APIs sensibles
- 🔒 Monitorear logs de acceso
- 🔒 Configurar backup de base de datos

## 📈 Escalabilidad

### GitHub Pages
- ✅ CDN global automático
- ✅ 100GB de ancho de banda/mes gratis
- ✅ Escalabilidad automática

### Clever Cloud
- ✅ Escalabilidad horizontal y vertical
- ✅ Base de datos PostgreSQL gestionada
- ✅ Backup automático

## 🎯 Próximas Mejoras

1. **Autenticación de usuarios** en GitHub Pages
2. **Dashboard de estadísticas** avanzado
3. **Personalización de QR** (colores, logos)
4. **API versioning** (`/v1/api/`)
5. **Caché** con Redis
6. **Notificaciones** por email/webhook
7. **Múltiples formatos** de exportación
8. **QR dinámicos** (editar destino sin regenerar)

## 🤝 Contribución

1. Fork del repositorio
2. Crear rama feature: `git checkout -b feature/nueva-funcionalidad`
3. Commit cambios: `git commit -m 'Añadir nueva funcionalidad'`
4. Push a la rama: `git push origin feature/nueva-funcionalidad`
5. Crear Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver `LICENSE` para más detalles.

---

**¡Sistema QR Híbrido funcionando! 🎉**

- 🌐 **Frontend**: https://bigbossspektrum.github.io/QR
- ⚡ **Backend**: https://tu-app.cleverapps.io
- 🔐 **Admin**: https://tu-app.cleverapps.io/admin
