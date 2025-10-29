from django.db import models


class EnglishChatMessage(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    user_message = models.TextField(blank=True)
    agent_message = models.TextField(blank=True)

    class Meta:
        verbose_name = "Chat Message (English)"
        verbose_name_plural = "Chat Messages (English)"

    def __str__(self):
        return (self.user_message or "").strip()[:50]
