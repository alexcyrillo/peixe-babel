import 'package:flutter/material.dart';

class FlashcardPage extends StatelessWidget {
  const FlashcardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Aqui você poderá visualizar e gerenciar os flashcards ligados à API.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
