from .views import EnglishCardReviewViewSet, EnglishCardViewSet
from rest_framework.routers import SimpleRouter

router = SimpleRouter()
router.register(r'flashcards', EnglishCardViewSet, basename='englishcard')
router.register(r'review', EnglishCardReviewViewSet, basename='englishcard-review')
