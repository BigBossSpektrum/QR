#!/bin/bash

# 🚀 Script de Deploy Automatizado - Sistema QR Híbrido
# Backend (API) → Clever Cloud | Frontend (Estático) → GitHub Pages

set -e  # Salir si hay algún error

echo "🚀 Iniciando deploy del Sistema QR Híbrido..."
echo "📊 Backend API: Clever Cloud | Frontend Estático: GitHub Pages"
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "manage.py" ]; then
    echo "❌ Error: No se encuentra manage.py. Ejecuta desde la raíz del proyecto."
    exit 1
fi

# Función para preguntar al usuario
ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Por favor responde y o n.";;
        esac
    done
}

echo "🔧 Preparando archivos para deploy híbrido..."

# Asegurar que requirements.txt esté actualizado
if ! grep -q "django-cors-headers" requirements.txt; then
    echo "django-cors-headers==4.3.1" >> requirements.txt
    echo "✅ django-cors-headers agregado a requirements.txt"
fi

if ! grep -q "psycopg2-binary" requirements.txt; then
    echo "psycopg2-binary==2.9.7" >> requirements.txt
    echo "✅ psycopg2-binary agregado a requirements.txt"
fi

# ==================================================
# PASO 1: DEPLOY BACKEND A CLEVER CLOUD
# ==================================================

echo ""
echo "🌩️  STEP 1: DEPLOY BACKEND A CLEVER CLOUD"
echo "=========================================="

if ask_yes_no "¿Quieres hacer deploy del backend a Clever Cloud?"; then
    
    # Verificar si clever-tools está instalado
    if ! command -v clever &> /dev/null; then
        echo "📦 Instalando Clever Cloud CLI..."
        npm install -g clever-tools
    fi
    
    # Verificar login
    echo "🔐 Verificando login a Clever Cloud..."
    if ! clever profile; then
        echo "🔑 Por favor, inicia sesión en Clever Cloud:"
        clever login
    fi
    
    # Variables de entorno necesarias
    echo "🔧 Configurando variables de entorno..."
    
    # Configuración de base de datos PostgreSQL
    clever env set POSTGRESQL_ADDON_DB "bihckcsbxtpycru7fzc3"
    clever env set POSTGRESQL_ADDON_HOST "bihckcsbxtpycru7fzc3-postgresql.services.clever-cloud.com"
    clever env set POSTGRESQL_ADDON_PASSWORD "XpZCCVNaceAKNvn0wK3GgdqTpK3A7o"
    clever env set POSTGRESQL_ADDON_PORT "5432"
    clever env set POSTGRESQL_ADDON_URI "postgresql://uv24d06xzigvcazpqhub:XpZCCVNaceAKNvn0wK3GgdqTpK3A7o@bihckcsbxtpycru7fzc3-postgresql.services.clever-cloud.com:5432/bihckcsbxtpycru7fzc3"
    clever env set POSTGRESQL_ADDON_USER "uv24d06xzigvcazpqhub"
    clever env set POSTGRESQL_ADDON_VERSION "15"
    
    # Configuración Django
    read -p "Ingresa tu SECRET_KEY para Django (o presiona Enter para generar una nueva): " SECRET_KEY
    if [ -z "$SECRET_KEY" ]; then
        SECRET_KEY=$(python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")
        echo "✅ SECRET_KEY generada automáticamente"
    fi
    clever env set SECRET_KEY "$SECRET_KEY"
    
    clever env set DEBUG "False"
    clever env set DJANGO_SETTINGS_MODULE "qr_site.clever_cloud_settings"
    
    # CORS para GitHub Pages
    clever env set CORS_ALLOWED_ORIGINS "https://bigbossspektrum.github.io"
    
    # Obtener el dominio de la app
    APP_DOMAIN=$(clever domain list | grep -o 'app-[a-z0-9-]*\.cleverapps\.io' | head -n1)
    if [ -z "$APP_DOMAIN" ]; then
        APP_DOMAIN="app-your-id.cleverapps.io"
        echo "⚠️  No se pudo detectar el dominio automáticamente"
        read -p "Ingresa tu dominio de Clever Cloud (ej: app-abc123.cleverapps.io): " APP_DOMAIN
    fi
    
    clever env set ALLOWED_HOSTS "$APP_DOMAIN,localhost,127.0.0.1"
    
    echo "📊 Variables de entorno configuradas:"
    clever env list
    
    echo "🚀 Iniciando deploy a Clever Cloud..."
    clever deploy
    
    echo "✅ Deploy a Clever Cloud completado!"
    echo "🔗 Backend API disponible en: https://$APP_DOMAIN"
    echo "🔐 Admin panel: https://$APP_DOMAIN/admin"
    
    # Crear un archivo con la URL del backend para el frontend
    echo "$APP_DOMAIN" > backend_url.txt
    
else
    echo "⏭️  Saltando deploy a Clever Cloud"
    APP_DOMAIN="app-your-id.cleverapps.io"
    
    # Leer URL del backend si existe el archivo
    if [ -f "backend_url.txt" ]; then
        APP_DOMAIN=$(cat backend_url.txt)
        echo "📋 Usando backend previamente configurado: $APP_DOMAIN"
    else
        read -p "Ingresa la URL de tu backend en Clever Cloud (sin https://): " APP_DOMAIN
        echo "$APP_DOMAIN" > backend_url.txt
    fi
fi

# ==================================================
# PASO 2: GENERAR ARCHIVOS ESTÁTICOS PARA GITHUB PAGES
# ==================================================

echo ""
echo "📄 STEP 2: GENERAR ARCHIVOS PARA GITHUB PAGES"
echo "=============================================="

if ask_yes_no "¿Quieres generar archivos estáticos para GitHub Pages?"; then
    
    echo "🎨 Generando archivos estáticos del frontend..."
    
    # Ejecutar el script de generación
    chmod +x generate-github-pages.sh
    
    # Actualizar la URL del backend en el script de generación
    sed -i "s|backend_api_url = 'https://tu-app.cleverapps.io'|backend_api_url = 'https://$APP_DOMAIN'|g" generate-github-pages.sh
    
    # Ejecutar la generación
    ./generate-github-pages.sh
    
    echo "✅ Archivos estáticos generados en ./github-pages/"
    
else
    echo "⏭️  Saltando generación de archivos estáticos"
fi

# ==================================================
# PASO 3: DEPLOY A GITHUB PAGES
# ==================================================

echo ""
echo "� STEP 3: DEPLOY A GITHUB PAGES"
echo "================================="

if ask_yes_no "¿Quieres hacer deploy a GitHub Pages?"; then
    
    # Verificar que existen los archivos estáticos
    if [ ! -f "github-pages/index.html" ]; then
        echo "❌ Error: No se encontraron archivos estáticos. Ejecuta primero la generación."
        exit 1
    fi
    
    echo "📤 Subiendo archivos estáticos a GitHub..."
    
    # Añadir archivos al repositorio
    git add github-pages/
    git add backend_url.txt
    
    # Commit los cambios
    git commit -m "🌐 Actualizar frontend estático para GitHub Pages

✨ Características:
- Frontend estático completamente funcional
- Conectado con backend API: https://$APP_DOMAIN
- Interfaz moderna con Bootstrap 5
- Sistema híbrido Clever Cloud + GitHub Pages

🔧 Cambios:
- Archivos estáticos actualizados
- URL del backend configurada
- CORS habilitado para GitHub Pages" || echo "No hay cambios para commitear"
    
    # Push al repositorio
    git push origin main
    
    echo "✅ Deploy a GitHub Pages completado!"
    echo "🔗 Frontend estático disponible en: https://bigbossspektrum.github.io/QR"
    
    echo ""
    echo "📋 Configurar GitHub Pages:"
    echo "1. Ve a Settings > Pages en tu repositorio"
    echo "2. Selecciona 'Deploy from a branch'"
    echo "3. Elige 'main' branch"
    echo "4. Selecciona '/ (root)' folder"
    echo "5. Activa 'GitHub Pages' para usar ./github-pages/"
    
else
    echo "⏭️  Saltando deploy a GitHub Pages"
fi

# ==================================================
# RESUMEN FINAL
# ==================================================

echo ""
echo "🎉 DEPLOY HÍBRIDO COMPLETADO!"
echo "=============================="
echo ""
echo "🏗️  ARQUITECTURA IMPLEMENTADA:"
echo "   � Frontend Estático → GitHub Pages"
echo "   🖥️  Backend API → Clever Cloud"
echo "   💾 Base de Datos → PostgreSQL (Clever Cloud)"
echo ""
echo "�🔗 URLs de tu sistema:"
echo "   🌐 Frontend: https://bigbossspektrum.github.io/QR"
echo "   ⚡ Backend:  https://$APP_DOMAIN"
echo "   🔐 Admin:    https://$APP_DOMAIN/admin"
echo ""
echo "� FLUJO DE FUNCIONAMIENTO:"
echo "   1. Usuario visita GitHub Pages"
echo "   2. Llena formulario para generar QR"
echo "   3. JavaScript envía datos a Clever Cloud API"
echo "   4. Backend genera QR y lo guarda en BD"
echo "   5. Usuario escanea QR → Redirección via Clever Cloud"
echo ""
echo "📋 Próximos pasos:"
echo "   1. ⏰ Esperar 2-5 minutos para propagación"
echo "   2. 🔧 Configurar GitHub Pages si no está activo"
echo "   3. 🧪 Probar generación de QR en frontend"
echo "   4. 📱 Probar escaneo de QR generado"
echo "   5. 🔐 Crear superusuario: clever run python manage.py createsuperuser"
echo ""
echo "🆘 En caso de problemas:"
echo "   - Verificar CORS en settings de Clever Cloud"
echo "   - Verificar variables de entorno"
echo "   - Revisar logs: clever logs"
echo "   - Contactar soporte si persisten errores"
echo ""
echo ""
echo "🧪 Para testing local:"
echo "  python manage.py runserver --settings=qr_site.local_clever_settings"
echo ""
echo "📚 Documentación completa en: INSTRUCCIONES_DESPLIEGUE_HIBRIDO.md"
echo ""
echo "¡Feliz deployment! 🚀"
