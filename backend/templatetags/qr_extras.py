from django import template
import qrcode
import io
import base64
from django.conf import settings

register = template.Library()

@register.filter
def generar_qr_base64(codigo_uuid):
    """
    Filtro personalizado para generar un código QR en base64
    a partir de un UUID de código QR
    """
    try:
        from django.http import HttpRequest
        from django.test import RequestFactory
        
        # Crear una request ficticia para generar la URL completa
        factory = RequestFactory()
        request = factory.get('/')
        
        # Construir la URL de redirección
        redirect_url = f"https://tu-dominio.com/backend/qr/{codigo_uuid}/"
        
        # Generar el código QR
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=8,
            border=2,
        )
        qr.add_data(redirect_url)
        qr.make(fit=True)
        
        # Crear la imagen
        img = qr.make_image(fill_color="black", back_color="white")
        
        # Convertir a base64
        buffer = io.BytesIO()
        img.save(buffer, format='PNG')
        buffer.seek(0)
        img_base64 = base64.b64encode(buffer.getvalue()).decode()
        
        return img_base64
    except Exception as e:
        # En caso de error, retornar una cadena vacía
        return ""
