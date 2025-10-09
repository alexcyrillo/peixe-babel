from rest_framework import serializers
from flashcard.models.english_card import EnglishCard


class ReviewSerializer(serializers.ModelSerializer):
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
            'word',
            'translation',
            'meaning',
            'examples',
            'interval',
            'repetitions',
            'next_review',
            'created_at',
            'updated_at',
        )
        extra_kwargs = {
            'easiness_factor': {'required': True},
        }