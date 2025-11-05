import 'package:flutter/material.dart';
import 'package:peixe_babel/pages/conversation_page.dart';
import 'package:peixe_babel/pages/main_flashcard_page.dart';
import 'package:peixe_babel/theme/app_theme.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peixe Babel'), centerTitle: true),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primary),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Onde você quer começar?',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore os recursos do Peixe Babel e avance no aprendizado.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _openPage(context, const MainFlashcardPage()),
                        icon: const Icon(Icons.style),
                        label: const Text('Flashcards'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _openPage(context, const ConversationPage()),
                        icon: const Icon(Icons.forum),
                        label: const Text('Conversa com IA'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
