from django.utils import timezone
from rest_framework import serializers
from flashcard.models import EnglishCard
from flashcard.services.english_field_generator import english_fields_generator
from supermemo2 import first_review

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

    def create(self, validated_data):
        today = timezone.now()
        word = validated_data.get('word')
        generated = english_fields_generator(word)
        validated_data['translation'] = generated["translation"]
        validated_data['meaning'] = generated["meaning"]

        srs = first_review(0)
        validated_data['easiness_factor'] = srs.get('easiness')
        validated_data['interval'] = srs.get('interval')
        validated_data['repetitions'] = srs.get('repetitions')
        validated_data['next_review'] = today

        return super().create(validated_data)