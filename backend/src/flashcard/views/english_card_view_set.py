from django.utils import timezone

from rest_framework import mixins,viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response

from supermemo2 import review

from flashcard.models.english_card import EnglishCard
from flashcard.serializers.english_card_serializers import EnglishCardSerializer

class EnglishCardViewSet(viewsets.ModelViewSet):
    queryset = EnglishCard.objects.all()
    serializer_class = EnglishCardSerializer

    @action(detail=True, methods=['post'])
    def flashcards(self, request, pk=None):
        instance = self.get_object()

        data = request.data.copy()

        serializer = self.get_serializer(instance, data=data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)