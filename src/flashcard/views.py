from .models import EnglishCard
from .serializers import EnglishCardSerializer

from rest_framework import generics, viewsets, mixins
from rest_framework.generics import get_object_or_404
from rest_framework.decorators import action
from rest_framework.response import Response


class FlashcardAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = EnglishCard.objects.all()
    serializer_class = EnglishCardSerializer

    
class FlashcardsAPIView(generics.ListCreateAPIView):
    queryset = EnglishCard.objects.all()
    serializer_class = EnglishCardSerializer
