from django.urls import path
from .views import FlashcardAPIView, FlashcardsAPIView

urlpatterns = [
    path('flashcards/', FlashcardsAPIView.as_view(),name='flashcards'),
    path('flashcards/<int:pk>/', FlashcardAPIView.as_view(),name='flashcard')
]
