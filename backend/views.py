from django.shortcuts import get_object_or_404, redirect, render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.contrib.auth.decorators import login_required
import qrcode
import io
import base64
from .models import CodigoQR
import json

def redirigir_qr(request, codigo):
    qr = get_object_or_404(CodigoQR, codigo=codigo)
    
    # Verificar si el código QR está activo
    if not qr.activo:
        return render(request, 'backend/qr_deshabilitado.html', {
            'codigo': qr.codigo,
            'descripcion': qr.descripcion
        })
    
    # Incrementar contador de accesos solo si está activo
    qr.accesos += 1
    qr.save()
    return redirect(qr.contenido)

@csrf_exempt
@require_http_methods(["POST"])
@login_required
def generar_qr(request):
    try:
        # Debug: verificar usuario
        print(f"Usuario autenticado: {request.user.is_authenticated}")
        print(f"Usuario: {request.user}")
        
        data = json.loads(request.body)
        url = data.get('url')
        descripcion = data.get('descripcion', '')
        
        if not url:
            return JsonResponse({'error': 'URL es requerida'}, status=400)
        
        # Crear el objeto en la base de datos asociado al usuario
        codigo_qr = CodigoQR.objects.create(
            contenido=url,
            descripcion=descripcion,
            usuario=request.user
        )
        
        print(f"QR creado: {codigo_qr.codigo}")
        
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
            'descripcion': descripcion,
            'usuario': request.user.username
        })
        
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@login_required
def descargar_qr(request, codigo):
    try:
        # Solo permitir descargar códigos QR del usuario actual
        codigo_qr = get_object_or_404(CodigoQR, codigo=codigo, usuario=request.user)
        
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
        response['Content-Disposition'] = f'attachment; filename="qr_{request.user.username}_{codigo_qr.descripcion or "sin_descripcion"}_{codigo}.png"'
        
        # Guardar la imagen en la respuesta
        img.save(response, format='PNG')
        
        return response
        
    except Exception as e:
        return HttpResponse(f'Error: {str(e)}', status=500)

@login_required
def generar_qr_preview(request, codigo):
    """Vista para generar una imagen QR de vista previa"""
    try:
        codigo_qr = get_object_or_404(CodigoQR, codigo=codigo, usuario=request.user)
        
        # Generar la URL de redirección
        redirect_url = f"{request.scheme}://{request.get_host()}/backend/qr/{codigo_qr.codigo}/"
        
        # Generar el código QR más pequeño para preview
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=6,
            border=2,
        )
        qr.add_data(redirect_url)
        qr.make(fit=True)
        
        # Crear la imagen
        img = qr.make_image(fill_color="black", back_color="white")
        
        # Preparar la respuesta HTTP
        response = HttpResponse(content_type='image/png')
        
        # Guardar la imagen en la respuesta
        img.save(response, format='PNG')
        
        return response
        
    except Exception as e:
        return HttpResponse(f'Error: {str(e)}', status=500)

@login_required
def mis_qr_codes(request):
    """Vista para mostrar todos los códigos QR del usuario"""
    codigos = CodigoQR.objects.filter(usuario=request.user)
    
    # Calcular estadísticas
    total_accesos = sum(codigo.accesos for codigo in codigos)
    codigos_activos = codigos.filter(activo=True)
    codigos_inactivos = codigos.filter(activo=False)
    
    context = {
        'codigos': codigos,
        'total_codigos': codigos.count(),
        'codigos_activos': codigos_activos.count(),
        'codigos_inactivos': codigos_inactivos.count(),
        'total_accesos': total_accesos,
    }
    return render(request, 'backend/mis_qr_codes.html', context)

@csrf_exempt
@require_http_methods(["DELETE"])
@login_required
def eliminar_qr(request, codigo):
    """Vista para eliminar un código QR del usuario"""
    try:
        codigo_qr = get_object_or_404(CodigoQR, codigo=codigo, usuario=request.user)
        codigo_qr.delete()
        return JsonResponse({'success': True, 'message': 'Código QR eliminado exitosamente'})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
@require_http_methods(["POST"])
@login_required
def toggle_qr_estado(request, codigo):
    """Vista para habilitar/deshabilitar un código QR"""
    try:
        codigo_qr = get_object_or_404(CodigoQR, codigo=codigo, usuario=request.user)
        codigo_qr.activo = not codigo_qr.activo
        codigo_qr.save()
        
        estado = "habilitado" if codigo_qr.activo else "deshabilitado"
        return JsonResponse({
            'success': True, 
            'message': f'Código QR {estado} exitosamente',
            'activo': codigo_qr.activo
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)