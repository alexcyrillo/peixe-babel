from django.utils import timezone
from rest_framework import serializers
from flashcard.models import EnglishCard
from flashcard.serializers.utils import normalize_examples_payload
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

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['examples'] = normalize_examples_payload(data.get('examples') or [])
        return data

    def create(self, validated_data):
        today = timezone.now()
        word = validated_data.get('word')
        generated = english_fields_generator(word)
        if generated:
            validated_data['translation'] = generated.get("translation", "") or ""
            validated_data['meaning'] = generated.get("meaning", "") or ""
            examples = generated.get("examples")
            if isinstance(examples, list):
                validated_data['examples'] = normalize_examples_payload(examples)

        srs = first_review(0)
        validated_data['easiness_factor'] = srs.get('easiness')
        validated_data['interval'] = srs.get('interval')
        validated_data['repetitions'] = srs.get('repetitions')
        validated_data['next_review'] = today

        return super().create(validated_data)