from django.contrib.auth.models import User
from backend.models import CodigoQR

def admin_stats(request):
    """Context processor para estadísticas del admin"""
    if request.path.startswith('/admin/'):
        total_users = User.objects.count()
        total_qrs = CodigoQR.objects.count()
        total_accesos = sum(CodigoQR.objects.values_list('accesos', flat=True))
        
        return {
            'total_users': total_users,
            'total_qrs': total_qrs,
            'total_accesos': total_accesos,
        }
    return {}
