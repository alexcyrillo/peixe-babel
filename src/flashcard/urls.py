from .views import EnglishCardViewSet
from rest_framework.routers import SimpleRouter

router = SimpleRouter()
router.register('en/flashcard', EnglishCardViewSet)