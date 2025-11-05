import 'package:flutter/material.dart';
import 'package:peixe_babel/services/api/flashcard_api.dart';
import 'package:peixe_babel/theme/app_theme.dart';

class FlashcardCardPage extends StatefulWidget {
  const FlashcardCardPage({
    super.key,
    required this.flashcardId,
    this.initialCard,
  });

  final int flashcardId;
  final Map<String, dynamic>? initialCard;

  @override
  State<FlashcardCardPage> createState() => _FlashcardCardPageState();
}

class _FlashcardCardPageState extends State<FlashcardCardPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _wordController;
  late final TextEditingController _translationController;
  late final TextEditingController _meaningController;
  final List<TextEditingController> _exampleSentenceControllers = [];
  final List<TextEditingController> _exampleTranslationControllers = [];

  bool _isFetching = false;
  bool _isSaving = false;
  bool _isDeleting = false;
  bool _hasChanges = false;
  String? _loadError;
  Map<String, dynamic>? _currentCard;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController();
    _translationController = TextEditingController();
    _meaningController = TextEditingController();

    final initial = widget.initialCard;
    if (initial != null) {
      _applyCardData(initial);
      _currentCard = initial;
    } else {
      _resetExampleControllers(const <Map<String, String>>[]);
    }

    _fetchFlashcard();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    _meaningController.dispose();
    for (final controller in _exampleSentenceControllers) {
      controller.dispose();
    }
    for (final controller in _exampleTranslationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchFlashcard() async {
    setState(() {
      _isFetching = true;
      _loadError = null;
    });

    try {
      final card = await flashcardApi.getFlashcard(widget.flashcardId);
      if (!mounted) {
        return;
      }
      setState(() {
        _currentCard = card;
        _applyCardData(card);
        _isFetching = false;
      });
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loadError = e.message;
        _isFetching = false;
      });
    }
  }

  Map<String, String>? _normalizeExample(Object? value) {
    if (value == null) {
      return null;
    }

    String sentence = '';
    String translation = '';

    if (value is Map) {
      sentence = (value['sentence'] ?? value['example'] ?? value['text'] ?? '')
          .toString()
          .trim();
      translation =
          (value['translation'] ??
                  value['translation_pt'] ??
                  value['pt'] ??
                  value['portuguese'] ??
                  '')
              .toString()
              .trim();
    } else if (value is List && value.isNotEmpty) {
      sentence = value.first.toString().trim();
      if (value.length > 1) {
        translation = value[1].toString().trim();
      }
    } else {
      sentence = value.toString().trim();
    }

    if (sentence.isEmpty) {
      return null;
    }

    return {'sentence': sentence, 'translation': translation};
  }

  void _resetExampleControllers(List<Map<String, String>> examples) {
    for (final controller in _exampleSentenceControllers) {
      controller.dispose();
    }
    for (final controller in _exampleTranslationControllers) {
      controller.dispose();
    }
    _exampleSentenceControllers.clear();
    _exampleTranslationControllers.clear();

    if (examples.isEmpty) {
      _exampleSentenceControllers.add(TextEditingController());
      _exampleTranslationControllers.add(TextEditingController());
      return;
    }

    for (final example in examples) {
      _exampleSentenceControllers.add(
        TextEditingController(text: example['sentence'] ?? ''),
      );
      _exampleTranslationControllers.add(
        TextEditingController(text: example['translation'] ?? ''),
      );
    }
  }

  void _addExampleRow() {
    setState(() {
      _exampleSentenceControllers.add(TextEditingController());
      _exampleTranslationControllers.add(TextEditingController());
    });
  }

  void _removeExampleRow(int index) {
    if (index < 0 || index >= _exampleSentenceControllers.length) {
      return;
    }

    final sentenceController = _exampleSentenceControllers[index];
    final translationController = _exampleTranslationControllers[index];

    setState(() {
      _exampleSentenceControllers.removeAt(index);
      _exampleTranslationControllers.removeAt(index);

      if (_exampleSentenceControllers.isEmpty) {
        _exampleSentenceControllers.add(TextEditingController());
        _exampleTranslationControllers.add(TextEditingController());
      }
    });

    sentenceController.dispose();
    translationController.dispose();
  }

  List<Map<String, String>> _collectExamples() {
    final examples = <Map<String, String>>[];
    final total = _exampleSentenceControllers.length;

    for (var i = 0; i < total; i++) {
      final sentence = _exampleSentenceControllers[i].text.trim();
      final translation = _exampleTranslationControllers.length > i
          ? _exampleTranslationControllers[i].text.trim()
          : '';

      if (sentence.isEmpty && translation.isEmpty) {
        continue;
      }
      if (sentence.isEmpty) {
        continue;
      }

      examples.add({'sentence': sentence, 'translation': translation});
    }

    return examples;
  }

  void _applyCardData(Map<String, dynamic> card) {
    _wordController.text = (card['word'] ?? '').toString();
    _translationController.text = (card['translation'] ?? '').toString();
    _meaningController.text = (card['meaning'] ?? '').toString();

    final rawExamples = card['examples'];
    final examples = <Map<String, String>>[];

    if (rawExamples is List) {
      for (final example in rawExamples) {
        final normalized = _normalizeExample(example);
        if (normalized != null) {
          examples.add(normalized);
        }
      }
    } else {
      final normalized = _normalizeExample(rawExamples);
      if (normalized != null) {
        examples.add(normalized);
      }
    }

    _resetExampleControllers(examples);
  }

  Widget _buildExampleRow(int index) {
    final sentenceController = _exampleSentenceControllers[index];
    final translationController = _exampleTranslationControllers[index];
    final isLast = index == _exampleSentenceControllers.length - 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: sentenceController,
                  decoration: InputDecoration(
                    labelText: 'Exemplo ${index + 1} (inglês)',
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _exampleSentenceControllers.length > 1
                    ? () => _removeExampleRow(index)
                    : null,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Remover exemplo',
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: translationController,
            decoration: const InputDecoration(labelText: 'Tradução'),
            textInputAction: isLast
                ? TextInputAction.done
                : TextInputAction.next,
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    final payload = <String, dynamic>{
      'word': _wordController.text.trim(),
      'translation': _translationController.text.trim(),
      'meaning': _meaningController.text.trim(),
      'examples': _collectExamples(),
    };

    try {
      await flashcardApi.updateFlashcard(id: widget.flashcardId, data: payload);

      if (!mounted) {
        return;
      }

      _hasChanges = true;
      Navigator.of(context).pop(true);
      return;
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir flashcard'),
        content: const Text(
          'Tem certeza de que deseja excluir este flashcard? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    setState(() => _isDeleting = true);

    try {
      await flashcardApi.deleteFlashcard(id: widget.flashcardId);

      if (!mounted) {
        return;
      }

      _hasChanges = true;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Widget _buildBody() {
    if (_isFetching && _currentCard == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null && _currentCard == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_loadError!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isFetching ? null : _fetchFlashcard,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Card(
              elevation: 6,
              shadowColor: AppColors.deepBlue.withOpacity(0.12),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_isFetching) const LinearProgressIndicator(),
                      if (_isFetching) const SizedBox(height: 16),
                      TextFormField(
                        controller: _wordController,
                        decoration: const InputDecoration(labelText: 'Palavra'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe a palavra.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _translationController,
                        decoration: const InputDecoration(
                          labelText: 'Tradução',
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _meaningController,
                        decoration: const InputDecoration(
                          labelText: 'Significado',
                        ),
                        maxLines: null,
                        minLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Exemplos',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(
                        _exampleSentenceControllers.length,
                        (index) => _buildExampleRow(index),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: _addExampleRow,
                          icon: const Icon(Icons.add),
                          label: const Text('Adicionar exemplo'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Dica: mantenha frases curtas em inglês e inclua a tradução correspondente para cada exemplo.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_hasChanges);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Flashcard'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(_hasChanges),
          ),
          actions: [
            IconButton(
              onPressed: _isFetching ? null : _fetchFlashcard,
              icon: const Icon(Icons.refresh),
              tooltip: 'Atualizar',
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primary),
          child: _buildBody(),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepBlue.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: (_isSaving || _isDeleting) ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar alterações'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: (_isSaving || _isDeleting) ? null : _delete,
                    icon: _isDeleting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.delete_outline),
                    label: Text(
                      _isDeleting ? 'Excluindo...' : 'Excluir flashcard',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
