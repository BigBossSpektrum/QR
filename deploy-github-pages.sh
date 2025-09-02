#!/bin/bash

# Script para migrar a GitHub Pages

echo "🚀 Configurando GitHub Pages..."

# 1. Crear rama gh-pages si no existe
git checkout -b gh-pages 2>/dev/null || git checkout gh-pages

# 2. Copiar archivos de GitHub Pages al root
cp -r github-pages/* .

# 3. Crear archivo .nojekyll para servir archivos estáticos
echo "" > .nojekyll

# 4. Crear CNAME si tienes dominio personalizado (opcional)
# echo "tu-dominio.com" > CNAME

# 5. Commit y push
git add .
git commit -m "Deploy GitHub Pages interface"
git push -u origin gh-pages

echo "✅ GitHub Pages configurado!"
echo ""
echo "📍 Pasos finales:"
echo "1. Ve a: https://github.com/BigBossSpektrum/QR/settings/pages"
echo "2. Source: Deploy from a branch"
echo "3. Branch: gh-pages"
echo "4. Folder: / (root)"
echo ""
echo "🌐 Tu sitio estará disponible en:"
echo "   https://bigbossspektrum.github.io/QR/"
echo ""
echo "⚙️ Configuración híbrida con Clever Cloud:"
echo "• Interfaz: GitHub Pages (gratis, estático)"
echo "• Backend: Clever Cloud (para redirecciones y estadísticas)"
echo "• Base de datos: PostgreSQL en Clever Cloud"
echo "• Lo mejor de ambos mundos! 🎉"
echo ""
echo "🔗 Siguiente paso: Configurar Clever Cloud"
echo "   Ejecuta: ./deploy-clever-cloud.sh"
