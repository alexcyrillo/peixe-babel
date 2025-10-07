from .models import EnglishCard
from .serializers import EnglishCardSerializer

from rest_framework import generics, viewsets, mixins
from rest_framework.generics import get_object_or_404
from rest_framework.decorators import action
from rest_framework.response import Response


class EnglishCardViewSet(viewsets.ModelViewSet):
    queryset = EnglishCard.objects.all()
    serializer_class = EnglishCardSerializer

    @action(detail=True, methods=('post'))
    def flashcards(self, request, pk=None):
        queryset = EnglishCard.objects.all()
        serializer_class = EnglishCardSerializer