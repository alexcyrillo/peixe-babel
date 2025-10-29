import 'package:flutter/material.dart';
import 'package:peixe_babel/src/features/flashcard_create/create_flashcard_page.dart';
import 'package:peixe_babel/src/features/flashcard_list/list_flashcards_page.dart';
import 'package:peixe_babel/src/features/flashcard_review/review_page.dart';

class FlashcardPage extends StatelessWidget {
  const FlashcardPage({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () =>
                    _openPage(context, const CreateFlashcardPage()),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Criar novo flashcard'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _openPage(context, const ListFlashcardsPage()),
                icon: const Icon(Icons.view_list),
                label: const Text('Ver flashcards existentes'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _openPage(context, const ReviewPage()),
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Iniciar revisão'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
