# Migración a GitHub Pages

## Opción 1: Generador de QR Estático (Cliente)

### Ventajas:
- ✅ Funciona 100% en GitHub Pages
- ✅ No requiere servidor
- ✅ Generación instantánea
- ✅ Exportar/Descargar QRs

### Desventajas:
- ❌ No hay base de datos
- ❌ No hay contador de accesos
- ❌ No hay autenticación
- ❌ QRs apuntan directamente al destino

### Implementación:
1. HTML + JavaScript puro
2. Librería QR.js para generar QRs
3. LocalStorage para guardar historial (opcional)

## Opción 2: GitHub Actions + Jekyll

### Ventajas:
- ✅ Generación automática
- ✅ Páginas dinámicas con Jekyll
- ✅ Historial en archivos YAML

### Desventajas:
- ❌ No hay contadores en tiempo real
- ❌ Regeneración manual necesaria

## Opción 3: Híbrida (Recomendada para tu caso)

### Mantener:
- Django app en Render (para lógica backend)
- GitHub Pages (para interfaz estática)

### Flujo:
1. Interfaz estática en GitHub Pages
2. API calls a tu Django en Render
3. Lo mejor de ambos mundos
