from flashcard.models.english_card import EnglishCard


def get_vocabulary():
  card_list = EnglishCard.objects.all()
  vocabulary_list = []

  for word in card_list:
    vocabulary_list.append(word.get_word())

  return vocabulary_list