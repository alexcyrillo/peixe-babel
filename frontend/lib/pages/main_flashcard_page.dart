import 'package:flutter/material.dart';
import 'package:peixe_babel/pages/flashcard/create_flashcard_page.dart';
import 'package:peixe_babel/pages/flashcard/list_flashcard_page.dart';
import 'package:peixe_babel/pages/flashcard/review_flashcard_page.dart';
import 'package:peixe_babel/widgets/button_widget.dart';

class MainFlashcardPage extends StatelessWidget {
  const MainFlashcardPage({super.key});

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
              ButtonWidget(
                onPressed: () =>
                    _openPage(context, const CreateFlashcardPage()),
                icon: Icons.add_circle_outline,
                text: 'Criar novo flashcard',
              ),
              const SizedBox(height: 16),
              ButtonWidget(
                onPressed: () => _openPage(context, const ListFlashcardsPage()),
                icon: Icons.view_list,
                text: 'Ver flashcards existentes',
              ),
              const SizedBox(height: 16),
              ButtonWidget(
                onPressed: () =>
                    _openPage(context, const ReviewFlashcardPage()),
                icon: Icons.play_circle_outline,
                text: 'Iniciar revisão',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
