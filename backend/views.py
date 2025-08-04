from django.shortcuts import get_object_or_404, redirect, render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
import qrcode
import io
import base64
from .models import CodigoQR
import json

def redirigir_qr(request, codigo):
    qr = get_object_or_404(CodigoQR, codigo=codigo)
    return redirect(qr.contenido)

@csrf_exempt
@require_http_methods(["POST"])
def generar_qr(request):
    try:
        data = json.loads(request.body)
        url = data.get('url')
        descripcion = data.get('descripcion', '')
        
        if not url:
            return JsonResponse({'error': 'URL es requerida'}, status=400)
        
        # Crear el objeto en la base de datos
        codigo_qr = CodigoQR.objects.create(
            contenido=url,
            descripcion=descripcion
        )
        
        # Generar la URL de redirección
        redirect_url = f"{request.scheme}://{request.get_host()}/backend/qr/{codigo_qr.codigo}/"
        
        # Generar el código QR
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=10,
            border=4,
        )
        qr.add_data(redirect_url)
        qr.make(fit=True)
        
        # Crear la imagen
        img = qr.make_image(fill_color="black", back_color="white")
        
        # Convertir a base64 para mostrar en el frontend
        buffer = io.BytesIO()
        img.save(buffer, format='PNG')
        buffer.seek(0)
        img_base64 = base64.b64encode(buffer.getvalue()).decode()
        
        return JsonResponse({
            'success': True,
            'codigo': str(codigo_qr.codigo),
            'imagen_base64': img_base64,
            'redirect_url': redirect_url,
            'descripcion': descripcion
        })
        
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

def descargar_qr(request, codigo):
    try:
        codigo_qr = get_object_or_404(CodigoQR, codigo=codigo)
        
        # Generar la URL de redirección
        redirect_url = f"{request.scheme}://{request.get_host()}/backend/qr/{codigo_qr.codigo}/"
        
        # Generar el código QR
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=10,
            border=4,
        )
        qr.add_data(redirect_url)
        qr.make(fit=True)
        
        # Crear la imagen
        img = qr.make_image(fill_color="black", back_color="white")
        
        # Preparar la respuesta HTTP
        response = HttpResponse(content_type='image/png')
        response['Content-Disposition'] = f'attachment; filename="qr_code_{codigo}.png"'
        
        # Guardar la imagen en la respuesta
        img.save(response, format='PNG')
        
        return response
        
    except Exception as e:
        return HttpResponse(f'Error: {str(e)}', status=500)