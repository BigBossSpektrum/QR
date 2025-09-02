# 🚀 Configuración Completa: GitHub Pages + Clever Cloud

## ✅ **Estado Actual**

### **✓ Base de Datos Configurada**
- PostgreSQL en Clever Cloud ✅
- Migraciones ejecutadas ✅
- Superusuario creado (admin) ✅
- Conexión verificada ✅

### **✓ Archivos Creados**
- `qr_site/clever_cloud_settings.py` ✅
- `qr_site/local_clever_settings.py` ✅
- `clevercloud/python.json` ✅
- `github-pages/index.html` ✅
- `deploy-clever-cloud.sh` ✅
- `Procfile` ✅

## 🎯 **Próximos Pasos**

### **1. Deploy en Clever Cloud**

#### **Opción A: Interfaz Web**
1. Ve a https://console.clever-cloud.com/
2. **Create an application** → **Python**
3. Conecta tu repositorio GitHub: `BigBossSpektrum/QR`
4. Branch: `qr-server`

#### **Variables de Entorno en Clever Cloud:**
```bash
DJANGO_SETTINGS_MODULE=qr_site.clever_cloud_settings
SECRET_KEY=tu-secret-key-muy-segura-y-aleatoria-aqui
POSTGRESQL_ADDON_HOST=bihckcsbxtpycru7fzc3-postgresql.services.clever-cloud.com
POSTGRESQL_ADDON_DB=bihckcsbxtpycru7fzc3
POSTGRESQL_ADDON_USER=uv24d06xzigvcazpqhub
POSTGRESQL_ADDON_PORT=5432
POSTGRESQL_ADDON_PASSWORD=XpZCCVNaceAKNvn0wK3GgdqTpK3A7o
POSTGRESQL_ADDON_URI=postgresql://uv24d06xzigvcazpqhub:XpZCCVNaceAKNvn0wK3GgdqTpK3A7o@bihckcsbxtpycru7fzc3-postgresql.services.clever-cloud.com:5432/bihckcsbxtpycru7fzc3
```

#### **Opción B: CLI (si tienes Node.js)**
```bash
# Instalar CLI
npm install -g clever-tools

# Login
clever login

# Crear app y configurar
clever create --type python qr-generator
clever env set DJANGO_SETTINGS_MODULE qr_site.clever_cloud_settings
clever env set SECRET_KEY 'tu-secret-key-muy-segura-aqui'
clever env set POSTGRESQL_ADDON_HOST bihckcsbxtpycru7fzc3-postgresql.services.clever-cloud.com
clever env set POSTGRESQL_ADDON_DB bihckcsbxtpycru7fzc3
clever env set POSTGRESQL_ADDON_USER uv24d06xzigvcazpqhub
clever env set POSTGRESQL_ADDON_PORT 5432
clever env set POSTGRESQL_ADDON_PASSWORD XpZCCVNaceAKNvn0wK3GgdqTpK3A7o
clever env set POSTGRESQL_ADDON_URI 'postgresql://uv24d06xzigvcazpqhub:XpZCCVNaceAKNvn0wK3GgdqTpK3A7o@bihckcsbxtpycru7fzc3-postgresql.services.clever-cloud.com:5432/bihckcsbxtpycru7fzc3'

# Deploy
clever deploy
```

### **2. Deploy GitHub Pages**

```bash
# Ejecutar script (desde Git Bash)
./deploy-github-pages.sh

# O manualmente:
# 1. Ve a: https://github.com/BigBossSpektrum/QR/settings/pages
# 2. Source: Deploy from a branch
# 3. Branch: gh-pages
# 4. Folder: / (root)
```

### **3. Conectar Ambos**

Una vez que tengas la URL de Clever Cloud (ej: `https://app-12345678-1234-4321-1234-123456789abc.cleverapps.io`):

1. Actualiza la URL en `github-pages/index.html`:
```javascript
value="https://tu-url-de-clever-cloud.cleverapps.io"
```

2. Commit y push:
```bash
git add .
git commit -m "Update Clever Cloud URL"
git push origin gh-pages
```

## 🌐 **URLs Finales**

### **Frontend (GitHub Pages):**
- https://bigbossspektrum.github.io/QR/

### **Backend API (Clever Cloud):**
- https://tu-app.cleverapps.io/

### **Admin Django:**
- https://tu-app.cleverapps.io/admin/
- Usuario: `admin`
- Contraseña: `[la que creaste]`

## 🎮 **Funcionalidad Completa**

### **Modo Directo (GitHub Pages):**
```
Usuario → Genera QR → Apunta directamente al destino
```
- ✅ Sin costo de servidor
- ✅ Funciona offline
- ❌ Sin estadísticas

### **Modo Híbrido (GitHub Pages + Clever Cloud):**
```
Usuario → Genera QR → Clever Cloud → Redirige al destino
```
- ✅ Estadísticas de acceso
- ✅ URLs cortas y limpias
- ✅ Control de habilitación/deshabilitación
- ✅ Gestión por usuario

## 💰 **Costos**

| Servicio | Plan | Costo |
|----------|------|-------|
| GitHub Pages | Gratis | €0/mes |
| Clever Cloud | Starter | €0/mes* |
| **Total** | | **€0/mes** |

*Clever Cloud gratis hasta 20M requests/mes

## 🔄 **Flujo de Trabajo**

### **Para Desarrollo:**
```bash
# Trabajar localmente con base de datos de Clever Cloud
python manage.py runserver --settings=qr_site.local_clever_settings
```

### **Para Producción:**
```bash
# Push a GitHub activa ambos deploys automáticamente
git push origin qr-server  # → Clever Cloud
git push origin gh-pages   # → GitHub Pages
```

## 🎯 **Casos de Uso Perfectos**

### **CVs Digitales:**
- Código QR en CV físico → GitHub Pages con tu portfolio
- **Ventaja:** URLs cortas, estadísticas de visitas

### **Portafolios:**
- Tarjetas de presentación → Proyectos en GitHub Pages
- **Ventaja:** Control total, cambiar destino sin reimprimir

### **Proyectos:**
- QR en presentaciones → Demos live en GitHub Pages
- **Ventaja:** URLs profesionales y rastreables

## 🔧 **Testing Local**

```bash
# Probar con configuración de Clever Cloud
python manage.py runserver --settings=qr_site.local_clever_settings

# Abrir: http://localhost:8000
```

## 🎉 **¡Ya Estás Listo!**

Tu sistema híbrido está configurado y listo para desplegar:

1. **Frontend elegante** en GitHub Pages
2. **Backend potente** en Clever Cloud  
3. **Base de datos robusta** en PostgreSQL
4. **Costo total: €0** 💸

**¡El futuro de los códigos QR es tuyo! 🚀**
