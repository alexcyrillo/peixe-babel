from rest_framework import serializers
from flashcard.models.chat_message import EnglishChatMessage


class EnglishChatSerializer(serializers.ModelSerializer):
    class Meta:
        model = EnglishChatMessage
        fields = (
            'created_at',
            'user_message',
            'agent_message',
        )
        read_only_fields = (
            'created_at', 
            'agent_message',
        )
        extra_kwargs = {
            'user_message': {'required': True},
        }