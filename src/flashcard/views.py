from django.utils import timezone
from .models import EnglishCard
from .serializers import EnglishCardSerializer

from rest_framework import mixins,viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response

from supermemo2 import review

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
    
class EnglishCardReviewViewSet(viewsets.ViewSet):
    def get_queryset(self):
        today = timezone.localdate()
        return EnglishCard.objects.filter(next_review__date__lte=today)

    def list(self, request):
        queryset = self.get_queryset()
        serializer = EnglishCardSerializer(queryset, many=True)
        return Response(serializer.data)
    
    def partial_update(self, request, pk=None):


        if 'score' not in request.data:
            return Response({'detail': 'O campo "score" é obrigatório.'}, status=status.HTTP_400_BAD_REQUEST)
        
        instance = self.get_object()

        resultado = review(request.data.get('score'), instance["easiness_factor"], instance["interval"], instance["repetitions"], instance["next_review"])

        instance["easiness_factor"] = resultado["easiness"]
        instance["interval"] = resultado["interval"]
        instance["repetitions"] = resultado["repetitions"]
        instance["next_review"] = resultado["review_datetime"]

        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
