from rest_framework import serializers
from flashcard.models import EnglishCard
from flashcard.services.english_field_generator import english_fields_generator

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
        word = validated_data.get('word')
        generated = english_fields_generator(word)
        validated_data['translation'] = generated["translation"]
        validated_data['meaning'] = generated["meaning"]


        return super().create(validated_data)