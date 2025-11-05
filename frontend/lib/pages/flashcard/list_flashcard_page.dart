import 'package:flutter/material.dart';
import 'package:peixe_babel/services/api/flashcard_api.dart';

import 'flashcard_card_page.dart';

const Map<String, String> _diacriticReplacements = {
  'á': 'a',
  'à': 'a',
  'â': 'a',
  'ã': 'a',
  'ä': 'a',
  'å': 'a',
  'é': 'e',
  'è': 'e',
  'ê': 'e',
  'ë': 'e',
  'í': 'i',
  'ì': 'i',
  'î': 'i',
  'ï': 'i',
  'ó': 'o',
  'ò': 'o',
  'ô': 'o',
  'õ': 'o',
  'ö': 'o',
  'ú': 'u',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'ç': 'c',
  'ñ': 'n',
  'ý': 'y',
  'ÿ': 'y',
};

String _stripDiacritics(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_diacriticReplacements[char] ?? char);
  }
  return buffer.toString();
}

class ListFlashcardsPage extends StatefulWidget {
  const ListFlashcardsPage({super.key});

  @override
  State<ListFlashcardsPage> createState() => _ListFlashcardsPageState();
}

class _ListFlashcardsPageState extends State<ListFlashcardsPage> {
  late Future<List<Map<String, dynamic>>> _flashcardsFuture;
  late final TextEditingController _searchController;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _flashcardsFuture = flashcardApi.getFlashcards();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final future = flashcardApi.getFlashcards();
    setState(() {
      _flashcardsFuture = future;
    });
    await future;
  }

  List<Map<String, dynamic>> _filterFlashcards(
    List<Map<String, dynamic>> cards,
  ) {
    final query = _normalizeSearchText(_searchTerm);
    if (query.isEmpty) {
      return cards;
    }

    return cards.where((card) {
      final word = _normalizeSearchText(card['word']);
      final translation = _normalizeSearchText(card['translation']);
      return word.contains(query) || translation.contains(query);
    }).toList();
  }

  String _normalizeSearchText(Object? value) {
    final text = value?.toString().toLowerCase().trim() ?? '';
    if (text.isEmpty) {
      return '';
    }

    return _stripDiacritics(text);
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Pesquisar por palavra ou tradução',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchTerm.trim().isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchTerm = '');
                },
                icon: const Icon(Icons.clear),
              ),
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) => setState(() => _searchTerm = value),
    );
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
            final filteredFlashcards = _filterFlashcards(flashcards);
            final hasResults = filteredFlashcards.isNotEmpty;
            final itemCount = (hasResults ? filteredFlashcards.length : 1) + 1;

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: itemCount,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildSearchField();
                }

                if (!hasResults) {
                  final message = _searchTerm.trim().isEmpty
                      ? 'Nenhum flashcard encontrado. Puxe para atualizar.'
                      : 'Nenhum flashcard encontrado para a pesquisa.';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(message, textAlign: TextAlign.center),
                    ),
                  );
                }

                final card = filteredFlashcards[index - 1];
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
