import uuid
from django.db import models

class CodigoQR(models.Model):
    codigo = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    contenido = models.TextField()  # Puede ser URL, texto, etc.
    creado = models.DateTimeField(auto_now_add=True)
    descripcion = models.CharField(max_length=255, blank=True)

    def __str__(self):
        return str(self.codigo)