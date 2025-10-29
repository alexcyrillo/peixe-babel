import 'package:flutter/material.dart';
import 'package:peixe_babel/src/features/ai_chat/conversation_page.dart';
import 'package:peixe_babel/src/features/flashcard_index_page.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peixe Babel'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openPage(context, const FlashcardPage()),
                icon: const Icon(Icons.style),
                label: const Text('Flashcards'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _openPage(context, const ConversationPage()),
                icon: const Icon(Icons.forum),
                label: const Text('Conversa com IA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
