from .views import EnglishCardViewSet
from rest_framework.routers import SimpleRouter

router = SimpleRouter()
router.register('flashcard/english', EnglishCardViewSet)

# urlpatterns = [
#     path('flashcards/', FlashcardsAPIView.as_view(),name='flashcards'),
#     path('flashcards/<int:pk>/', FlashcardAPIView.as_view(),name='flashcard')
# ]
