
from rest_framework.routers import SimpleRouter

from flashcard.views import EnglishCardReviewViewSet, EnglishCardViewSet, EnglishAiChatViewSet

router = SimpleRouter()
router.register(r'flashcards', EnglishCardViewSet, basename='englishcard')
router.register(r'review', EnglishCardReviewViewSet, basename='englishcard-review')
router.register(r'chat', EnglishAiChatViewSet, basename='englishcard-chat')
