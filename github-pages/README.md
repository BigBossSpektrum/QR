# Configuración para GitHub Pages

github-pages/
├── index.html          # Interfaz principal
├── _config.yml         # Configuración Jekyll
├── README.md          # Documentación
└── assets/
    ├── css/
    │   └── custom.css
    └── js/
        └── qr-generator.js

## Pasos para Deploy:

1. **Habilitar GitHub Pages:**
   - Ve a Settings > Pages
   - Source: Deploy from a branch
   - Branch: main o master
   - Folder: /github-pages

2. **URL resultante:**
   - https://bigbossspektrum.github.io/QR/

3. **Funcionalidades:**
   - ✅ Generación QR directa (sin servidor)
   - ✅ Generación QR con redirección (usando Render)
   - ✅ Historial local (localStorage)
   - ✅ Descarga de QRs
   - ✅ Interfaz responsive

## Modos de Operación:

### Modo Directo:
- QR apunta directamente al destino
- No requiere servidor
- Perfecto para URLs simples

### Modo Redirección:
- QR apunta a tu servidor en Render
- Mantiene estadísticas y control
- Mejor para casos profesionales
