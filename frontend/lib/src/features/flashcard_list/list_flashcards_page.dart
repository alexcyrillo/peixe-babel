import 'package:flutter/material.dart';

class ListFlashcardsPage extends StatelessWidget {
  const ListFlashcardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards Criados')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Nesta tela você verá os flashcards existentes carregados da API.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
