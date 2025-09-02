#!/bin/bash

# 🚀 Script de Deploy Automatizado - Sistema QR Híbrido
# Clever Cloud + GitHub Pages

set -e  # Salir si hay algún error

echo "🚀 Iniciando deploy del Sistema QR Híbrido..."
echo "📊 Backend: Clever Cloud | Frontend: GitHub Pages"
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

echo "🔧 Preparando archivos..."

# Asegurar que requirements.txt esté actualizado
if ! grep -q "django-cors-headers" requirements.txt; then
    echo "django-cors-headers==4.3.1" >> requirements.txt
    echo "✅ django-cors-headers agregado a requirements.txt"
fi

# Deploy a Clever Cloud
echo ""
echo "🌩️  DEPLOY A CLEVER CLOUD"
echo "========================="

if ask_yes_no "¿Quieres hacer deploy a Clever Cloud?"; then
    
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
    echo "🔗 Backend disponible en: https://$APP_DOMAIN"
    echo "🔐 Admin panel: https://$APP_DOMAIN/admin"
    
else
    echo "⏭️  Saltando deploy a Clever Cloud"
    APP_DOMAIN="app-your-id.cleverapps.io"
fi

# Deploy a GitHub Pages
echo ""
echo "📄 DEPLOY A GITHUB PAGES"
echo "========================"

if ask_yes_no "¿Quieres hacer deploy a GitHub Pages?"; then
    
    echo "🔄 Cambiando a rama gh-pages..."
    
    # Guardar rama actual
    CURRENT_BRANCH=$(git branch --show-current)
    
    # Crear o cambiar a rama gh-pages
    if git show-ref --verify --quiet refs/heads/gh-pages; then
        git checkout gh-pages
    else
        git checkout -b gh-pages
    fi
    
    # Copiar archivos del frontend
    echo "📁 Copiando archivos frontend..."
    cp github-pages/* .
    
    # Actualizar URL del backend en el HTML
    echo "🔧 Actualizando configuración del frontend..."
    sed -i "s|http://127.0.0.1:8000|https://$APP_DOMAIN|g" index.html
    
    # Commit y push
    echo "📤 Subiendo a GitHub Pages..."
    git add .
    git commit -m "🌐 Deploy frontend GitHub Pages para QR System

✨ Funcionalidades:
- Interface dual: QR directo + Redirección
- Bootstrap UI responsive
- CORS configurado con backend
- Integración con Clever Cloud: $APP_DOMAIN"
    
    git push origin gh-pages
    
    # Volver a la rama original
    git checkout "$CURRENT_BRANCH"
    
    echo "✅ Deploy a GitHub Pages completado!"
    echo "🔗 Frontend disponible en: https://$(git config --get remote.origin.url | sed 's/.*github.com[:/]//' | sed 's/\.git$//' | sed 's/.*\///')"
    
else
    echo "⏭️  Saltando deploy a GitHub Pages"
fi

# Resumen final
echo ""
echo "🎉 DEPLOY COMPLETADO!"
echo "===================="
echo ""
echo "🔗 URLs de tu sistema:"
echo "  📱 Frontend: https://tu-usuario.github.io/QR"
echo "  🖥️  Backend:  https://$APP_DOMAIN"
echo "  🔐 Admin:    https://$APP_DOMAIN/admin"
echo ""
echo "📋 Próximos pasos:"
echo "  1. Activar GitHub Pages en Settings del repo"
echo "  2. Esperar ~5 minutos para propagación DNS"
echo "  3. Probar ambas interfaces"
echo ""
echo "🧪 Para testing local:"
echo "  python manage.py runserver --settings=qr_site.local_clever_settings"
echo ""
echo "📚 Documentación completa en: INSTRUCCIONES_DESPLIEGUE_HIBRIDO.md"
echo ""
echo "¡Feliz deployment! 🚀"
