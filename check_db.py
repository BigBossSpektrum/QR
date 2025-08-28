#!/usr/bin/env python3
"""
Script para verificar la configuración de la base de datos
Ejecutar con: python check_db.py
"""

import os
import sys
import django

# Configurar Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'qr_site.settings')

# Añadir el directorio del proyecto al path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

django.setup()

from django.conf import settings
from django.db import connection
from backend.models import CodigoQR
from django.contrib.auth.models import User

def check_database():
    print("🔍 VERIFICANDO CONFIGURACIÓN DE BASE DE DATOS")
    print("=" * 50)
    
    # 1. Verificar configuración
    db_config = settings.DATABASES['default']
    print(f"📊 Motor de BD: {db_config.get('ENGINE', 'N/A')}")
    print(f"🏠 Nombre BD: {db_config.get('NAME', 'N/A')}")
    print(f"🌐 Host: {db_config.get('HOST', 'local')}")
    
    # 2. Verificar variables de entorno
    database_url = os.environ.get('DATABASE_URL')
    if database_url:
        print(f"✅ DATABASE_URL configurada: {database_url[:30]}...")
    else:
        print("⚠️  DATABASE_URL no encontrada (usando SQLite local)")
    
    try:
        # 3. Probar conexión
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            print("✅ Conexión a la base de datos: EXITOSA")
        
        # 4. Verificar tablas
        if CodigoQR._meta.db_table in connection.introspection.table_names():
            print("✅ Tabla CodigoQR: EXISTE")
            
            # 5. Contar registros
            qr_count = CodigoQR.objects.count()
            user_count = User.objects.count()
            print(f"📊 Códigos QR en BD: {qr_count}")
            print(f"👥 Usuarios en BD: {user_count}")
            
            # 6. Mostrar últimos QR
            if qr_count > 0:
                print("\n📋 ÚLTIMOS 5 CÓDIGOS QR:")
                for qr in CodigoQR.objects.all().order_by('-creado')[:5]:
                    estado = "🟢 ACTIVO" if qr.activo else "🔴 INACTIVO"
                    print(f"  {qr.codigo} | {qr.usuario.username} | {estado} | {qr.accesos} accesos")
            
        else:
            print("❌ Tabla CodigoQR: NO EXISTE - Ejecutar migraciones")
            
    except Exception as e:
        print(f"❌ Error de conexión: {e}")
        return False
    
    print("\n" + "=" * 50)
    print("🎯 VERIFICACIÓN COMPLETADA")
    return True

if __name__ == "__main__":
    success = check_database()
    sys.exit(0 if success else 1)
