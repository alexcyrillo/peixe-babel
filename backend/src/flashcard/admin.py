from django.contrib import admin
from .models import EnglishCard

@admin.register(EnglishCard)
class EnglishCardAdmin(admin.ModelAdmin):
    list_display = ('word', 'translation', 'meaning', 'examples')
    search_fields = ('word', 'translation')
    ordering = ('word', 'translation')
