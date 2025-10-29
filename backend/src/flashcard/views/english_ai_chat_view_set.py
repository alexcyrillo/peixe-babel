from rest_framework import mixins, viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response

from flashcard.models.chat_message import EnglishChatMessage
from flashcard.serializers.english_chat_serializer import EnglishChatSerializer
from flashcard.services.chat_open_api import get_chat_response


class EnglishAiChatViewSet(mixins.CreateModelMixin,
                                     viewsets.GenericViewSet):
      queryset = EnglishChatMessage.objects.all()
      serializer_class = EnglishChatSerializer

      def create(self, request):
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)

            user_message = serializer.validated_data.get("user_message")
            instance = EnglishChatMessage.objects.create(user_message=user_message)

            try:
                  agent_text = get_chat_response(prompt=user_message)
            except Exception as exc:
                  return Response({"detail": str(exc)}, status=status.HTTP_502_BAD_GATEWAY)

            instance.agent_message = agent_text
            instance.save(update_fields=["agent_message"])

            return Response(self.get_serializer(instance).data, status=status.HTTP_201_CREATED)