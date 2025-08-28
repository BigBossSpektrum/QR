#!/usr/bin/env python3
"""
Script para probar manualmente la creación de QR
"""

import os
import sys
import django

# Configurar Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'qr_site.settings')

# Añadir el directorio del proyecto al path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

django.setup()

from backend.models import CodigoQR
from django.contrib.auth.models import User

def test_create_qr():
    print("🧪 PROBANDO CREACIÓN MANUAL DE QR")
    print("=" * 40)
    
    # Verificar usuario
    try:
        user = User.objects.get(username='testuser')
        print(f"✅ Usuario encontrado: {user.username}")
    except User.DoesNotExist:
        user = User.objects.create_user('testuser', 'test@test.com', 'test123')
        print(f"✅ Usuario creado: {user.username}")
    
    # Crear QR manualmente
    url_test = "https://www.google.com"
    descripcion_test = "QR de prueba manual"
    
    print(f"🔗 URL: {url_test}")
    print(f"📝 Descripción: {descripcion_test}")
    
    try:
        # Crear QR
        qr = CodigoQR.objects.create(
            contenido=url_test,
            descripcion=descripcion_test,
            usuario=user
        )
        
        print(f"✅ QR creado exitosamente!")
        print(f"🆔 Código: {qr.codigo}")
        print(f"👤 Usuario: {qr.usuario.username}")
        print(f"📅 Fecha: {qr.creado}")
        print(f"🟢 Activo: {qr.activo}")
        print(f"📊 Accesos: {qr.accesos}")
        
        # Verificar que se guardó
        total_qrs = CodigoQR.objects.count()
        print(f"📊 Total de QRs en BD: {total_qrs}")
        
        # Mostrar todos los QRs
        print("\n📋 TODOS LOS QR EN BD:")
        for qr_obj in CodigoQR.objects.all():
            estado = "🟢" if qr_obj.activo else "🔴"
            print(f"  {estado} {qr_obj.codigo} | {qr_obj.usuario.username} | {qr_obj.contenido[:50]}")
            
        return True
        
    except Exception as e:
        print(f"❌ Error al crear QR: {e}")
        return False

if __name__ == "__main__":
    success = test_create_qr()
    print("\n" + "=" * 40)
    print("🎯 PRUEBA COMPLETADA" if success else "❌ PRUEBA FALLIDA")
