import 'package:flutter/material.dart';
import 'package:peixe_babel/services/api/flashcard_api.dart';
import 'package:peixe_babel/theme/app_theme.dart';

import 'flashcard_card_page.dart';

enum _FlashcardSortOption { createdAtDesc, wordAsc, translationAsc }

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
  _FlashcardSortOption _sortOption = _FlashcardSortOption.createdAtDesc;

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

  List<Map<String, dynamic>> _sortFlashcards(List<Map<String, dynamic>> cards) {
    final sorted = List<Map<String, dynamic>>.from(cards);

    int compareStrings(Object? a, Object? b) {
      final textA = _normalizeSearchText(a);
      final textB = _normalizeSearchText(b);
      return textA.compareTo(textB);
    }

    DateTime _parseDate(Object? value) {
      if (value is DateTime) {
        return value;
      }
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
      }
      return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    }

    switch (_sortOption) {
      case _FlashcardSortOption.wordAsc:
        sorted.sort((a, b) => compareStrings(a['word'], b['word']));
        break;
      case _FlashcardSortOption.translationAsc:
        sorted.sort(
          (a, b) => compareStrings(a['translation'], b['translation']),
        );
        break;
      case _FlashcardSortOption.createdAtDesc:
        sorted.sort((a, b) {
          final dateA = _parseDate(a['created_at']);
          final dateB = _parseDate(b['created_at']);
          return dateB.compareTo(dateA);
        });
        break;
    }

    return sorted;
  }

  String _normalizeSearchText(Object? value) {
    final text = value?.toString().toLowerCase().trim() ?? '';
    if (text.isEmpty) {
      return '';
    }
    return _stripDiacritics(text);
  }

  String _sortLabel(_FlashcardSortOption option) {
    switch (option) {
      case _FlashcardSortOption.wordAsc:
        return 'Palavra (A-Z)';
      case _FlashcardSortOption.translationAsc:
        return 'Tradução (A-Z)';
      case _FlashcardSortOption.createdAtDesc:
        return 'Mais recentes';
    }
  }

  Widget _buildControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
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
          ),
          onChanged: (value) => setState(() => _searchTerm = value),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<_FlashcardSortOption>(
          value: _sortOption,
          decoration: const InputDecoration(
            labelText: 'Ordenar por',
            prefixIcon: Icon(Icons.sort_by_alpha),
          ),
          items: _FlashcardSortOption.values
              .map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(_sortLabel(option)),
                ),
              )
              .toList(),
          onChanged: (option) {
            if (option == null) {
              return;
            }
            setState(() => _sortOption = option);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards Criados')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primary),
        child: RefreshIndicator(
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(message, textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ],
                );
              }

              final flashcards = snapshot.data ?? const [];
              final filteredFlashcards = _sortFlashcards(
                _filterFlashcards(flashcards),
              );
              final hasResults = filteredFlashcards.isNotEmpty;
              final itemCount =
                  (hasResults ? filteredFlashcards.length : 1) + 1;

              return ListView.separated(
                padding: const EdgeInsets.all(24),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: itemCount,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildControls(),
                      ),
                    );
                  }

                  if (!hasResults) {
                    final message = _searchTerm.trim().isEmpty
                        ? 'Nenhum flashcard encontrado. Puxe para atualizar.'
                        : 'Nenhum flashcard encontrado para a pesquisa.';
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
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
                        builder: (_) => FlashcardCardPage(
                          flashcardId: id,
                          initialCard: card,
                        ),
                      ),
                    );

                    if (updated == true && mounted) {
                      await _refresh();
                    }
                  }

                  return Card(
                    shadowColor: AppColors.deepBlue.withOpacity(0.12),
                    elevation: 6,
                    child: InkWell(
                      onTap: handleTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: AppGradients.card,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                word?.isNotEmpty == true
                                    ? word!
                                    : 'Palavra desconhecida',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                translation?.isNotEmpty == true
                                    ? translation!
                                    : 'Tradução indisponível',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
