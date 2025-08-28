from django.urls import path
from django.urls import include
from . import views

urlpatterns = [
    path('qr/<uuid:codigo>/', views.redirigir_qr, name='redirigir_qr'),
    path('generar-qr/', views.generar_qr, name='generar_qr'),
    path('descargar-qr/<uuid:codigo>/', views.descargar_qr, name='descargar_qr'),
    path('preview-qr/<uuid:codigo>/', views.generar_qr_preview, name='generar_qr_preview'),
    path('eliminar-qr/<uuid:codigo>/', views.eliminar_qr, name='eliminar_qr'),
    path('mis-qr/', views.mis_qr_codes, name='mis_qr_codes'),
]