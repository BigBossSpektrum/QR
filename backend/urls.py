from django.urls import path
from django.urls import include
from . import views

urlpatterns = [
    path('qr/<uuid:codigo>/', views.redirigir_qr, name='redirigir_qr'),
]