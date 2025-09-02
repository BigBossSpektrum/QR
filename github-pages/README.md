# Generador QR - GitHub Pages

Este es el frontend estático del generador de códigos QR, desplegado en GitHub Pages.

## Características

- ✨ Interfaz moderna y responsiva
- 🔗 Conexión con backend API en Clever Cloud
- 📱 Compatible con dispositivos móviles
- 🎨 Diseño atractivo con Bootstrap

## Tecnologías

- HTML5, CSS3, JavaScript
- Bootstrap 5
- Font Awesome
- API REST (Clever Cloud)

## Uso

1. Visita: [https://bigbossspektrum.github.io/QR](https://bigbossspektrum.github.io/QR)
2. Ingresa la URL que quieres convertir a QR
3. Opcionalmente añade una descripción
4. Haz clic en "Generar QR"
5. Descarga tu código QR

Los códigos QR generados se guardan en la base de datos de Clever Cloud y las redirecciones funcionan a través del backend API.

## Backend API

- **URL**: https://tu-app.cleverapps.io
- **Endpoint**: `POST /backend/api/generar-qr/`
- **Redirección**: `GET /backend/qr/<uuid>/`
