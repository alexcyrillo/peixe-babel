import 'package:flutter/material.dart';
import 'package:peixe_babel/services/api/flashcard_api.dart';

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
  late final TextEditingController _examplesController;

  bool _isFetching = false;
  bool _isSaving = false;
  bool _hasChanges = false;
  String? _loadError;
  Map<String, dynamic>? _currentCard;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController();
    _translationController = TextEditingController();
    _meaningController = TextEditingController();
    _examplesController = TextEditingController();

    final initial = widget.initialCard;
    if (initial != null) {
      _applyCardData(initial);
      _currentCard = initial;
    }

    _fetchFlashcard();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    _meaningController.dispose();
    _examplesController.dispose();
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

  void _applyCardData(Map<String, dynamic> card) {
    _wordController.text = card['word']?.toString() ?? '';
    _translationController.text = card['translation']?.toString() ?? '';
    _meaningController.text = card['meaning']?.toString() ?? '';

    final examples = card['examples'];
    if (examples is List) {
      _examplesController.text = examples.map((e) => e.toString()).join('\n');
    } else if (examples != null) {
      _examplesController.text = examples.toString();
    } else {
      _examplesController.clear();
    }
  }

  List<String> _parseExamples(String value) {
    if (value.trim().isEmpty) {
      return <String>[];
    }

    return value
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
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
      'examples': _parseExamples(_examplesController.text),
    };

    try {
      final updated = await flashcardApi.updateFlashcard(
        id: widget.flashcardId,
        data: payload,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _currentCard = updated;
        _hasChanges = true;
        _applyCardData(updated);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flashcard atualizado com sucesso.')),
      );
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

  Widget _buildBody() {
    if (_isFetching && _currentCard == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null && _currentCard == null) {
      return Center(
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
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isFetching) const LinearProgressIndicator(),
            if (_isFetching) const SizedBox(height: 16),
            Text('ID: ${widget.flashcardId}'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _wordController,
              decoration: const InputDecoration(
                labelText: 'Palavra',
                border: OutlineInputBorder(),
              ),
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
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _meaningController,
              decoration: const InputDecoration(
                labelText: 'Significado',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              minLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _examplesController,
              decoration: const InputDecoration(
                labelText: 'Exemplos (um por linha)',
                border: OutlineInputBorder(),
              ),
              minLines: 3,
              maxLines: null,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_hasChanges);
        return false;
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
        body: _buildBody(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Salvar alterações'),
          ),
        ),
      ),
    );
  }
}
