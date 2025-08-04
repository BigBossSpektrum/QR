from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth.models import User

# Personalizar el admin de usuarios para mostrar información relacionada con QR
class UserAdmin(BaseUserAdmin):
    list_display = ('username', 'email', 'first_name', 'last_name', 'is_staff', 'date_joined', 'qr_count')
    list_filter = ('is_staff', 'is_superuser', 'is_active', 'date_joined')
    
    def qr_count(self, obj):
        """Muestra la cantidad de códigos QR creados por el usuario"""
        from backend.models import CodigoQR
        count = CodigoQR.objects.filter(usuario=obj).count()
        return f"📊 {count} QRs"
    qr_count.short_description = "Códigos QR"

# Reregistrar el modelo User con nuestro admin personalizado
admin.site.unregister(User)
admin.site.register(User, UserAdmin)
