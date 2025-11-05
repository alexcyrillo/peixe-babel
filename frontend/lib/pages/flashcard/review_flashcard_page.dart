import 'package:flutter/material.dart';
import 'package:peixe_babel/services/api/flashcard_api.dart';
import 'package:peixe_babel/theme/app_theme.dart';

class ReviewFlashcardPage extends StatefulWidget {
  const ReviewFlashcardPage({super.key});

  @override
  State<ReviewFlashcardPage> createState() => _ReviewFlashcardPageState();
}

class _ReviewFlashcardPageState extends State<ReviewFlashcardPage> {
  final List<Map<String, dynamic>> _queue = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cards = await flashcardApi.getReviewFlashcards();
      if (!mounted) return;
      setState(() {
        _queue
          ..clear()
          ..addAll(cards);
        _isLoading = false;
      });
      _resetPrompt();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic>? get _currentCard =>
      _queue.isEmpty ? null : _queue.first;

  void _resetPrompt() {
    if (!mounted) return;
    if (!_showAnswer) {
      return;
    }

    setState(() {
      _showAnswer = false;
    });
  }

  Future<void> _submitReview(num easiness) async {
    final card = _currentCard;
    if (card == null) {
      return;
    }

    final rawId = card['id'];
    final id = rawId is int
        ? rawId
        : rawId is num
        ? rawId.toInt()
        : null;

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível identificar o flashcard.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await flashcardApi.reviewFlashcard(id: id, easinessFactor: easiness);

      if (!mounted) return;

      setState(() {
        _queue.removeAt(0);
        _isSubmitting = false;
      });
      _resetPrompt();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _queue.isEmpty
                ? 'Revisão concluída!'
                : 'Flashcard atualizado. Restam ${_queue.length} para revisar.',
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Widget _buildExamples(List<String> examples) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text('Exemplos', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (examples.isEmpty)
          Text(
            'Exemplo não informado',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else
          ...examples.map(
            (example) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('- $example'),
            ),
          ),
      ],
    );
  }

  Widget _buildScrollableContent() {
    if (_isLoading && _queue.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: const [Center(child: CircularProgressIndicator())],
      );
    }

    if (_errorMessage != null && _queue.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _loadFlashcards,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_currentCard == null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: const [
          Center(
            child: Text(
              'Nenhum flashcard pendente de revisão hoje.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    final card = _currentCard!;
    final meaning = card['meaning']?.toString().trim();
    final translation = card['translation']?.toString().trim();
    final word = card['word']?.toString().trim();
    final Object? rawExamples = card['examples'];
    final examples = rawExamples is List
        ? rawExamples.map((e) => e.toString()).toList()
        : <String>[];
    final wordDisplay = word?.isNotEmpty == true
        ? word!
        : 'Palavra não informada';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        if (_isLoading) ...[
          const LinearProgressIndicator(),
          const SizedBox(height: 16),
        ],
        Text(
          'Restantes: ${_queue.length}',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 6,
          shadowColor: AppColors.deepBlue.withOpacity(0.12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.card),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_showAnswer) ...[
                    Text(
                      'Palavra',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      wordDisplay,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ] else ...[
                    Text(
                      word ?? 'Palavra',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      translation?.isNotEmpty == true
                          ? 'Tradução: $translation'
                          : 'Tradução não informada',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (meaning != null && meaning.isNotEmpty)
                      Text(
                        meaning,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    _buildExamples(examples),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildBottomActions() {
    final card = _currentCard;
    if (card == null || (_errorMessage != null && _queue.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
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
          child: !_showAnswer
              ? ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() => _showAnswer = true);
                        },
                  child: const Text('Responder'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Como foi a dificuldade?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => _submitReview(5),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emerald,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Fácil (5)'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => _submitReview(3),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryAccent,
                              foregroundColor: AppColors.textPrimary,
                            ),
                            child: const Text('Médio (3)'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => _submitReview(1),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Difícil (1)'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisar Flashcards'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadFlashcards,
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primary),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadFlashcards,
                child: _buildScrollableContent(),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }
}
