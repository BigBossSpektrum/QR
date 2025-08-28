#!/usr/bin/env python3
"""
Script para probar el endpoint de generación de QR directamente
"""

import os
import sys
import django
import json

# Configurar Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'qr_site.settings')

# Añadir el directorio del proyecto al path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

django.setup()

from django.test import Client
from django.contrib.auth.models import User
from backend.models import CodigoQR

def test_qr_endpoint():
    print("🧪 PROBANDO ENDPOINT DE GENERACIÓN QR")
    print("=" * 45)
    
    # Crear cliente de prueba
    client = Client()
    
    # Verificar usuario
    try:
        user = User.objects.get(username='testuser')
        print(f"✅ Usuario encontrado: {user.username}")
    except User.DoesNotExist:
        user = User.objects.create_user('testuser', 'test@test.com', 'test123')
        print(f"✅ Usuario creado: {user.username}")
    
    # Login
    login_success = client.login(username='testuser', password='test123')
    print(f"🔐 Login exitoso: {login_success}")
    
    if not login_success:
        print("❌ No se pudo hacer login")
        return False
    
    # Datos para el QR
    qr_data = {
        'url': 'https://www.ejemplo.com',
        'descripcion': 'QR de prueba desde endpoint'
    }
    
    print(f"🔗 URL: {qr_data['url']}")
    print(f"📝 Descripción: {qr_data['descripcion']}")
    
    # Contar QRs antes
    qrs_antes = CodigoQR.objects.count()
    print(f"📊 QRs antes: {qrs_antes}")
    
    try:
        # Hacer petición POST al endpoint
        response = client.post(
            '/backend/generar-qr/',
            data=json.dumps(qr_data),
            content_type='application/json'
        )
        
        print(f"📡 Status Code: {response.status_code}")
        print(f"📦 Response Headers: {dict(response.items())}")
        
        if response.status_code == 200:
            try:
                response_data = response.json()
                print(f"✅ Respuesta exitosa!")
                print(f"🆔 Código: {response_data.get('codigo', 'N/A')}")
                print(f"🔗 URL de redirección: {response_data.get('redirect_url', 'N/A')}")
                print(f"✅ Success: {response_data.get('success', False)}")
                
                # Contar QRs después
                qrs_despues = CodigoQR.objects.count()
                print(f"📊 QRs después: {qrs_despues}")
                print(f"➕ Diferencia: {qrs_despues - qrs_antes}")
                
                return True
            except json.JSONDecodeError as e:
                print(f"❌ Error decodificando JSON: {e}")
                print(f"📝 Contenido de respuesta: {response.content}")
                return False
        else:
            print(f"❌ Error en la petición: {response.status_code}")
            print(f"📝 Contenido: {response.content}")
            return False
            
    except Exception as e:
        print(f"❌ Error en la petición: {e}")
        return False

if __name__ == "__main__":
    success = test_qr_endpoint()
    print("\n" + "=" * 45)
    print("🎯 PRUEBA COMPLETADA" if success else "❌ PRUEBA FALLIDA")
