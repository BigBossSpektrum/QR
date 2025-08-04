from django.shortcuts import get_object_or_404, redirect
from .models import CodigoQR

def redirigir_qr(request, codigo):
    qr = get_object_or_404(CodigoQR, codigo=codigo)
    return redirect(qr.contenido)