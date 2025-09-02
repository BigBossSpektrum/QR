# URLs del Backend API (para Clever Cloud)
from django.urls import path
from . import views

urlpatterns = [
    # API endpoints para generar y gestionar QR
    path('api/generar-qr/', views.generar_qr, name='api_generar_qr'),
    path('api/mis-qr/', views.mis_qr_codes_api, name='api_mis_qr_codes'),
    path('api/eliminar-qr/<uuid:codigo>/', views.eliminar_qr_api, name='api_eliminar_qr'),
    path('api/toggle-qr/<uuid:codigo>/', views.toggle_qr_estado_api, name='api_toggle_qr_estado'),
    
    # Redirección de QR (cuando se escanea)
    path('qr/<uuid:codigo>/', views.redirigir_qr, name='redirigir_qr'),
    
    # Descargas y previsualizaciones
    path('descargar-qr/<uuid:codigo>/', views.descargar_qr, name='descargar_qr'),
    path('preview-qr/<uuid:codigo>/', views.generar_qr_preview, name='generar_qr_preview'),
]