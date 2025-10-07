from django.db import models
from django.utils import timezone

class BaseCard(models.Model):
    """
    O modelo base para todos os tipos de cards.
    Contém toda a lógica e campos comuns, como o algoritmo SRS.
    """
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # Campos do algoritmo SRS
    easiness_factor = models.FloatField(default=2.5)
    interval = models.IntegerField(default=0)
    repetitions = models.IntegerField(default=0)
    next_review = models.DateTimeField(default=timezone.now)

    class Meta:
        abstract = True