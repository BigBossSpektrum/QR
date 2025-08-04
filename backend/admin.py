from django.contrib import admin
from .models import CodigoQR

@admin.register(CodigoQR)
class CodigoQRAdmin(admin.ModelAdmin):
    list_display = ('codigo_corto', 'usuario', 'descripcion', 'accesos', 'creado')
    list_filter = ('creado', 'usuario', 'accesos')
    search_fields = ('codigo', 'descripcion', 'contenido', 'usuario__username')
    readonly_fields = ('codigo', 'creado', 'accesos')
    ordering = ('-creado',)
    list_per_page = 20
    
    fieldsets = (
        ('📋 Información Básica', {
            'fields': ('codigo', 'descripcion', 'usuario')
        }),
        ('🔗 Contenido', {
            'fields': ('contenido',),
            'description': 'La URL o contenido que será codificado en el QR'
        }),
        ('📊 Estadísticas', {
            'fields': ('accesos', 'creado'),
            'classes': ('collapse',),
            'description': 'Información de uso y fecha de creación'
        }),
    )
    
    def codigo_corto(self, obj):
        """Muestra una versión corta del código UUID"""
        return str(obj.codigo)[:8] + "..."
    codigo_corto.short_description = "🆔 Código"
    
    def has_change_permission(self, request, obj=None):
        """Solo el propietario o superusuario puede editar"""
        if obj and not request.user.is_superuser:
            return obj.usuario == request.user
        return super().has_change_permission(request, obj)
    
    def has_delete_permission(self, request, obj=None):
        """Solo el propietario o superusuario puede eliminar"""
        if obj and not request.user.is_superuser:
            return obj.usuario == request.user
        return super().has_delete_permission(request, obj)
    
    def get_queryset(self, request):
        """Mostrar solo los QR del usuario, excepto para superusuarios"""
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(usuario=request.user)
    
    def save_model(self, request, obj, form, change):
        """Asignar automáticamente el usuario actual si no está definido"""
        if not change:  # Solo en creación
            obj.usuario = request.user
        super().save_model(request, obj, form, change)

# Personalización del admin principal
admin.site.site_header = "🔲 QR Generator Admin"
admin.site.site_title = "QR Generator"
admin.site.index_title = "Panel de Administración"
