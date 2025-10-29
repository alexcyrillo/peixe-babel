from django.db import models
from django.contrib.postgres.fields import ArrayField
from flashcard.models.base_card import BaseCard


class EnglishCard(BaseCard):
    word = models.TextField()
    translation = models.TextField(blank=True)
    meaning = models.TextField(blank=True)
    examples = ArrayField(models.TextField(), blank=True, default=list)

    class Meta:
        verbose_name = "Card (English)"
        verbose_name_plural = "Cards (English)"
        constraints = [
            models.UniqueConstraint(
                fields=['word', 'translation'],
                name='unique_word_translation_per_card'
            ),
        ]

    def __str__(self):
        return self.word
