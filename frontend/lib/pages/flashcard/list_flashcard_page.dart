import 'package:flutter/material.dart';
import 'package:peixe_babel/services/api/flashcard_api.dart';

import 'flashcard_card_page.dart';

class ListFlashcardsPage extends StatefulWidget {
  const ListFlashcardsPage({super.key});

  @override
  State<ListFlashcardsPage> createState() => _ListFlashcardsPageState();
}

class _ListFlashcardsPageState extends State<ListFlashcardsPage> {
  late Future<List<Map<String, dynamic>>> _flashcardsFuture;

  @override
  void initState() {
    super.initState();
    _flashcardsFuture = flashcardApi.getFlashcards();
  }

  Future<void> _refresh() async {
    final future = flashcardApi.getFlashcards();
    setState(() {
      _flashcardsFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards Criados')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _flashcardsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              final message = snapshot.error is ApiException
                  ? (snapshot.error as ApiException).message
                  : 'Erro ao carregar os flashcards.';
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Center(child: Text(message, textAlign: TextAlign.center)),
                ],
              );
            }

            final flashcards = snapshot.data ?? const [];
            if (flashcards.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  Center(
                    child: Text(
                      'Nenhum flashcard encontrado. Puxe para atualizar.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: flashcards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final card = flashcards[index];
                final word = (card['word'] ?? '') as String?;
                final translation = (card['translation'] ?? '') as String?;

                Future<void> handleTap() async {
                  final rawId = card['id'];
                  final id = rawId is int
                      ? rawId
                      : rawId is num
                      ? rawId.toInt()
                      : null;

                  if (id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Não foi possível identificar o flashcard selecionado.',
                        ),
                      ),
                    );
                    return;
                  }

                  final updated = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) =>
                          FlashcardCardPage(flashcardId: id, initialCard: card),
                    ),
                  );

                  if (updated == true && mounted) {
                    await _refresh();
                  }
                }

                return Card(
                  child: InkWell(
                    onTap: handleTap,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            word?.isNotEmpty == true
                                ? word!
                                : 'Palavra desconhecida',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            translation?.isNotEmpty == true
                                ? translation!
                                : 'Tradução indisponível',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
