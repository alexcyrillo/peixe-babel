from .models import EnglishCard
from .serializers import EnglishCardSerializer

from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response

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