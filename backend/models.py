import uuid
from django.db import models
from django.contrib.auth.models import User

class CodigoQR(models.Model):
    codigo = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    contenido = models.TextField()  # Puede ser URL, texto, etc.
    creado = models.DateTimeField(auto_now_add=True)
    descripcion = models.CharField(max_length=255, blank=True)
    usuario = models.ForeignKey(User, on_delete=models.CASCADE)
    accesos = models.PositiveIntegerField(default=0)  # Contador de accesos
    activo = models.BooleanField(default=True)  # Estado del código QR

    def __str__(self):
        estado = "Activo" if self.activo else "Deshabilitado"
        return f"{self.usuario.username} - {str(self.codigo)[:8]} ({estado})"
    
    class Meta:
        ordering = ['-creado']