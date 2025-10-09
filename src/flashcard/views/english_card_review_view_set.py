from django.utils import timezone

from rest_framework import mixins,viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response

from supermemo2 import review

from flashcard.models.english_card import EnglishCard
from flashcard.serializers.english_card_serializers import EnglishCardSerializer
from flashcard.serializers.review_serializer import ReviewSerializer


class EnglishCardReviewViewSet(viewsets.GenericViewSet):
    queryset = EnglishCard.objects.all()
    serializer_class = ReviewSerializer

    def get_queryset(self):
        today = timezone.localdate()
        return EnglishCard.objects.filter(next_review__date__lte=today)

    def list(self, request):
        queryset = self.get_queryset()
        serializer = EnglishCardSerializer(queryset, many=True)
        return Response(serializer.data)

    def partial_update(self, request, pk=None):
        """
        Espera no body:
        {
            "score": int,  # dificuldade do card
            "outro_campo": str
        }
        """
        instance = self.get_object()

        print("---------------------")
        print(instance.easiness_factor)

        print("---------------------")
        print(request.data.get('easiness_factor'))

        resultado = review(request.data.get('easiness_factor'), instance.easiness_factor, instance.interval, instance.repetitions, instance.next_review)

        instance.easiness_factor = resultado["easiness"]
        instance.interval = resultado["interval"]
        instance.repetitions = resultado["repetitions"]
        instance.next_review = resultado["review_datetime"]

        print("---------------------")
        print(instance.easiness_factor)
        instance.save()


        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
