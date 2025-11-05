from rest_framework import serializers
from flashcard.models.english_card import EnglishCard
from flashcard.serializers.utils import normalize_examples_payload


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

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['examples'] = normalize_examples_payload(data.get('examples') or [])
        return data