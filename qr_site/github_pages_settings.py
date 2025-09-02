# Configuración para GitHub Pages (Frontend estático)
import os
from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'github-pages-static-key-no-server-side'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

# GitHub Pages configuration - solo para generar archivos estáticos
ALLOWED_HOSTS = [
    'bigbossspektrum.github.io',
    '.github.io',
    'localhost',
    '127.0.0.1'
]

# Application definition - Solo frontend para GitHub Pages
INSTALLED_APPS = [
    'django.contrib.staticfiles',
    'frontend',  # Solo el frontend
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'qr_site.github_urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.template.context_processors.static',
            ],
        },
    },
]

# No database for GitHub Pages - solo archivos estáticos
DATABASES = {}

# Internationalization
LANGUAGE_CODE = 'es'
TIME_ZONE = 'Europe/Madrid'
USE_I18N = True
USE_TZ = True

# Static files configuration for GitHub Pages
STATIC_URL = '/'
STATIC_ROOT = BASE_DIR / 'github-pages'

# Configuración de la API del backend en Clever Cloud
BACKEND_API_URL = 'https://tu-app.cleverapps.io'  # Cambiar por tu URL de Clever Cloud

# Configuración para archivos estáticos
STATICFILES_DIRS = [
    BASE_DIR / 'frontend' / 'static',
]

# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
