# 🚀 Sistema QR Híbrido: Clever Cloud + GitHub Pages

## 📋 Descripción
Sistema web híbrido para generación y gestión de códigos QR que combina lo mejor de dos mundos:
- **Frontend estático** en GitHub Pages (rápido, gratuito, confiable)
- **Backend Django** en Clever Cloud (gestión completa, base de datos)

## ✨ Funcionalidades Principales

### 🎯 Doble Modo de Operación
- **Modo Directo**: Generación instantánea de QR con JavaScript (sin backend)
- **Modo Redirección**: QR con tracking y gestión completa vía Django
- ✅ Interfaz web responsive
- ✅ Seguimiento de códigos generados

## 🛠️ Tecnologías

- **Backend**: Django 5.2.4
- **Base de datos**: PostgreSQL (producción) / SQLite (desarrollo)
- **Frontend**: HTML, CSS, JavaScript
- **Librerías**: qrcode, Pillow
- **Despliegue**: Render.com

## 📦 Instalación Local

1. Clona el repositorio:
```bash
git clone https://github.com/BigBossSpektrum/QR.git
cd QR
```

2. Crea un entorno virtual:
```bash
python -m venv env
source env/bin/activate  # En Windows: env\Scripts\activate
```

3. Instala las dependencias:
```bash
pip install -r requirements.txt
```

4. Ejecuta las migraciones:
```bash
python manage.py migrate
```

5. Inicia el servidor de desarrollo:
```bash
python manage.py runserver
```

6. Visita `http://127.0.0.1:8000/`

## 🌐 Despliegue en Render

### Opción 1: Usando render.yaml (Recomendado)

1. Sube tu código a GitHub
2. Conecta tu repositorio a Render
3. Render detectará automáticamente el archivo `render.yaml` y configurará:
   - Servicio web con Django
   - Base de datos PostgreSQL
   - Variables de entorno automáticas

### Opción 2: Configuración Manual

1. Crea un nuevo **Web Service** en Render
2. Conecta tu repositorio de GitHub
3. Configura los siguientes ajustes:
   - **Build Command**: `./build.sh`
   - **Start Command**: `gunicorn qr_site.wsgi:application`
   - **Environment**: `Python 3`

4. Crea una **PostgreSQL Database** en Render
5. Agrega las variables de entorno:
   - `DATABASE_URL`: (automática desde la BD)
   - `SECRET_KEY`: (genera una clave secreta)
   - `DEBUG`: `False`
   - `RENDER_EXTERNAL_HOSTNAME`: (tu dominio de Render)

## 🔧 Variables de Entorno

```bash
SECRET_KEY=tu-clave-secreta-super-segura
DEBUG=False
DATABASE_URL=postgresql://user:password@host:port/database
RENDER_EXTERNAL_HOSTNAME=tu-app.onrender.com
```

## 📝 Uso

1. Accede a la aplicación web
2. Ingresa la URL que quieres codificar
3. Opcionalmente agrega una descripción
4. Haz clic en "Generar Código QR"
5. Descarga el archivo PNG generado
6. ¡El código QR redirigirá a través de tu servidor!

## 🏗️ Estructura del Proyecto

```
QR/
├── backend/              # App Django para lógica de QR
├── frontend/             # App Django para interfaz web
├── qr_site/             # Configuración principal de Django
├── static/              # Archivos estáticos
├── requirements.txt     # Dependencias Python
├── build.sh            # Script de construcción para Render
├── render.yaml         # Configuración de Render
└── runtime.txt         # Versión de Python
```

## 🔗 URLs Disponibles

- `/` - Página principal con generador
- `/backend/generar-qr/` - API para generar códigos QR
- `/backend/descargar-qr/{uuid}/` - Descarga del código QR
- `/backend/qr/{uuid}/` - Redirección a la URL original
- `/admin/` - Panel de administración Django

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -am 'Agrega nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

## 👤 Autor

**BigBossSpektrum**
- GitHub: [@BigBossSpektrum](https://github.com/BigBossSpektrum)
