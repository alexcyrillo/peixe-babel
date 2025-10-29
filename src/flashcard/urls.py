
from rest_framework.routers import SimpleRouter

from flashcard.views import EnglishCardReviewViewSet, EnglishCardViewSet

router = SimpleRouter()
router.register(r'flashcards', EnglishCardViewSet, basename='englishcard')
router.register(r'review', EnglishCardReviewViewSet, basename='englishcard-review')
