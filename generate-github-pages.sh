#!/bin/bash

# Script para generar archivos estáticos para GitHub Pages

echo "🚀 Generando archivos estáticos para GitHub Pages..."

# Verificar que estamos en el directorio correcto
if [ ! -f "manage.py" ]; then
    echo "❌ Error: No se encuentra manage.py. Ejecuta desde la raíz del proyecto."
    exit 1
fi

# Activar entorno virtual si existe
if [ -d "env" ]; then
    echo "📦 Activando entorno virtual..."
    if [ -f "env/Scripts/activate" ]; then
        source env/Scripts/activate  # Windows
    elif [ -f "env/bin/activate" ]; then
        source env/bin/activate      # Linux/Mac
    fi
fi

# Configurar variables de entorno para GitHub Pages
export DJANGO_SETTINGS_MODULE=qr_site.github_pages_settings

echo "📝 Generando archivos estáticos..."

# Limpiar directorio de destino
if [ -d "github-pages" ]; then
    rm -rf github-pages/*
else
    mkdir -p github-pages
fi

# Configurar la URL del backend (cambiar por tu URL de Clever Cloud)
BACKEND_API_URL='https://tu-app.cleverapps.io'

# Buscar archivo con URL del backend si existe
if [ -f "backend_url.txt" ]; then
    BACKEND_URL_FROM_FILE=$(cat backend_url.txt)
    BACKEND_API_URL="https://$BACKEND_URL_FROM_FILE"
    echo "📋 Usando backend desde archivo: $BACKEND_API_URL"
fi

echo "🎨 Generando index.html desde template..."

# Crear index.html directamente usando el template como base
cat > github-pages/index.html << 'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generador QR - GitHub Pages</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #64748b;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --light-bg: #f8fafc;
            --dark-text: #1e293b;
        }

        body {
            background: linear-gradient(135deg, var(--light-bg) 0%, #e2e8f0 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        .main-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .header h1 {
            color: var(--primary-color);
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .header p {
            color: var(--secondary-color);
            font-size: 1.1rem;
        }

        .card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-color), #3b82f6);
            color: white;
            border-radius: 16px 16px 0 0 !important;
            padding: 1.5rem;
        }

        .card-body {
            padding: 2rem;
        }

        .form-control, .form-select {
            border-radius: 12px;
            border: 2px solid #e2e8f0;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
        }

        .btn {
            border-radius: 12px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), #3b82f6);
            border: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.4);
        }

        .qr-result {
            text-align: center;
            padding: 2rem;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .qr-image {
            border-radius: 12px;
            border: 4px solid var(--primary-color);
            padding: 1rem;
            background: white;
            margin: 1rem auto;
            display: inline-block;
        }

        .alert {
            border-radius: 12px;
            border: none;
            padding: 1rem 1.5rem;
        }

        .loading {
            display: none;
        }

        .loading.show {
            display: block;
        }

        .spinner-border {
            color: var(--primary-color);
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .feature-card {
            text-align: center;
            padding: 1.5rem;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 2rem;
            }
            .main-container {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Header -->
        <div class="header">
            <h1><i class="fas fa-qrcode"></i> Generador QR</h1>
            <p>Crea códigos QR personalizados de forma rápida y sencilla</p>
        </div>

        <!-- Generador QR -->
        <div class="card">
            <div class="card-header">
                <h3 class="mb-0"><i class="fas fa-magic"></i> Generar Código QR</h3>
            </div>
            <div class="card-body">
                <form id="qrForm">
                    <div class="row">
                        <div class="col-md-8 mb-3">
                            <label for="url" class="form-label">
                                <i class="fas fa-link"></i> URL o contenido
                            </label>
                            <input type="url" class="form-control" id="url" name="url" 
                                   placeholder="https://ejemplo.com" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="descripcion" class="form-label">
                                <i class="fas fa-tag"></i> Descripción (opcional)
                            </label>
                            <input type="text" class="form-control" id="descripcion" name="descripcion" 
                                   placeholder="Mi QR">
                        </div>
                    </div>
                    <div class="text-center">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-magic"></i> Generar QR
                        </button>
                    </div>
                </form>

                <!-- Loading -->
                <div class="loading text-center mt-4">
                    <div class="spinner-border" role="status">
                        <span class="visually-hidden">Generando...</span>
                    </div>
                    <p class="mt-2">Generando tu código QR...</p>
                </div>

                <!-- Resultado -->
                <div id="qrResult" class="mt-4" style="display: none;">
                    <div class="qr-result">
                        <h4 class="text-success"><i class="fas fa-check-circle"></i> ¡QR Generado!</h4>
                        <div id="qrImageContainer"></div>
                        <div class="mt-3">
                            <p class="mb-2"><strong>Descripción:</strong> <span id="qrDescripcion"></span></p>
                            <p class="mb-2"><strong>URL de redirección:</strong> <span id="qrRedirectUrl"></span></p>
                            <p class="mb-3"><strong>Código:</strong> <span id="qrCodigo"></span></p>
                            <button class="btn btn-success" onclick="descargarQR()">
                                <i class="fas fa-download"></i> Descargar QR
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Error -->
                <div id="errorAlert" class="alert alert-danger mt-4" style="display: none;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span id="errorMessage"></span>
                </div>
            </div>
        </div>

        <!-- Características -->
        <div class="feature-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-mobile-alt"></i>
                </div>
                <h5>Escaneo Fácil</h5>
                <p>Compatible con cualquier lector de QR</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-cloud"></i>
                </div>
                <h5>En la Nube</h5>
                <p>Tus códigos se guardan de forma segura</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-chart-bar"></i>
                </div>
                <h5>Estadísticas</h5>
                <p>Rastrea cuántas veces se escanea</p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
EOF

# Añadir la configuración del backend dinámicamente
echo "        const BACKEND_API_URL = '$BACKEND_API_URL';" >> github-pages/index.html

# Continuar con el resto del JavaScript
cat >> github-pages/index.html << 'EOF'
        let currentQRData = null;

        document.getElementById('qrForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const url = document.getElementById('url').value;
            const descripcion = document.getElementById('descripcion').value;
            
            if (!url) {
                mostrarError('Por favor, ingresa una URL válida');
                return;
            }

            mostrarLoading(true);
            ocultarResultados();

            try {
                const response = await fetch(`${BACKEND_API_URL}/backend/api/generar-qr/`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        url: url,
                        descripcion: descripcion
                    })
                });

                const data = await response.json();

                if (data.success) {
                    mostrarQR(data);
                } else {
                    mostrarError(data.error || 'Error al generar el código QR');
                }
            } catch (error) {
                console.error('Error:', error);
                mostrarError('Error de conexión. Verifica que el backend esté funcionando.');
            } finally {
                mostrarLoading(false);
            }
        });

        function mostrarQR(data) {
            currentQRData = data;
            
            document.getElementById('qrImageContainer').innerHTML = 
                `<img src="data:image/png;base64,${data.imagen_base64}" alt="Código QR" class="qr-image">`;
            
            document.getElementById('qrDescripcion').textContent = data.descripcion || 'Sin descripción';
            document.getElementById('qrRedirectUrl').textContent = data.redirect_url;
            document.getElementById('qrCodigo').textContent = data.codigo;
            
            document.getElementById('qrResult').style.display = 'block';
        }

        function mostrarError(mensaje) {
            document.getElementById('errorMessage').textContent = mensaje;
            document.getElementById('errorAlert').style.display = 'block';
        }

        function ocultarResultados() {
            document.getElementById('qrResult').style.display = 'none';
            document.getElementById('errorAlert').style.display = 'none';
        }

        function mostrarLoading(show) {
            const loading = document.querySelector('.loading');
            if (show) {
                loading.classList.add('show');
            } else {
                loading.classList.remove('show');
            }
        }

        function descargarQR() {
            if (currentQRData) {
                const link = document.createElement('a');
                link.href = `data:image/png;base64,${currentQRData.imagen_base64}`;
                link.download = `qr_${currentQRData.descripcion || 'codigo'}_${currentQRData.codigo}.png`;
                link.click();
            }
        }

        // Validación en tiempo real de la URL
        document.getElementById('url').addEventListener('input', function(e) {
            const url = e.target.value;
            if (url && !isValidUrl(url)) {
                e.target.setCustomValidity('Por favor, ingresa una URL válida (debe incluir http:// o https://)');
            } else {
                e.target.setCustomValidity('');
            }
        });

        function isValidUrl(string) {
            try {
                new URL(string);
                return true;
            } catch (_) {
                return false;
            }
        }
    </script>
</body>
</html>
EOF

# Crear _config.yml para GitHub Pages
echo "📄 Creando _config.yml..."
cat > github-pages/_config.yml << EOF
# GitHub Pages configuration
title: "Generador QR"
description: "Generador de códigos QR con backend en Clever Cloud"
baseurl: ""
url: "https://bigbossspektrum.github.io"

# Jekyll configuration
markdown: kramdown
highlighter: rouge
theme: minima

# Exclude files
exclude:
  - README.md
  - Gemfile
  - Gemfile.lock
  - node_modules
  - vendor
  - .bundle
  - .sass-cache
  - .jekyll-cache
  - .jekyll-metadata

# Include files
include:
  - _config.yml

# GitHub Pages specific
plugins:
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag
EOF

# Crear README.md para GitHub Pages
echo "📖 Creando README.md..."
cat > github-pages/README.md << EOF
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

- **URL**: $BACKEND_API_URL
- **Endpoint**: \`POST /backend/api/generar-qr/\`
- **Redirección**: \`GET /backend/qr/<uuid>/\`
EOF

# Verificar que los archivos se generaron correctamente
if [ -f "github-pages/index.html" ]; then
    echo "✅ Archivos estáticos generados correctamente en ./github-pages/"
    echo "📁 Archivos creados:"
    ls -la github-pages/
    echo ""
    echo "🔗 Backend configurado para: $BACKEND_API_URL"
else
    echo "❌ Error al generar archivos estáticos"
    exit 1
fi

echo ""
echo "🎉 ¡Generación completada!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Si no tienes backend desplegado, ejecuta: ./deploy-hibrido.sh"
echo "2. Committea y pushea los cambios:"
echo "   git add github-pages/"
echo "   git commit -m 'Actualizar archivos estáticos para GitHub Pages'"
echo "   git push origin main"
echo "3. Configura GitHub Pages en Settings > Pages"
echo "4. Prueba tu generador en: https://bigbossspektrum.github.io/QR"
echo ""
