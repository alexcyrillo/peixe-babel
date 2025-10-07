from rest_framework import serializers
from flashcard.models import EnglishCard

class EnglishCardSerializer(serializers.ModelSerializer):
    class Meta:
        model = EnglishCard
        fields = (
            'id',
            'word',
            'translation',
            'meaning',
            'examples',
            'easiness_factor',
            'interval',
            'repetitions',
            'next_review',
            'created_at',
            'updated_at',
        )
        read_only_fields = (
            'id',
            'meaning',
            'examples',
            'easiness_factor',
            'interval',
            'repetitions',
            'next_review',
            'created_at',
            'updated_at',
        )
        extra_kwargs = {
            'word': {'required': True},
            'translation': {'required': False},
        }
