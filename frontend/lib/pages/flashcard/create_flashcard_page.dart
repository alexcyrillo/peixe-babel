import 'package:flutter/material.dart';
import 'package:peixe_babel/services/api/flashcard_api.dart';
import 'package:peixe_babel/theme/app_theme.dart';

class CreateFlashcardPage extends StatefulWidget {
  const CreateFlashcardPage({super.key});

  @override
  State<CreateFlashcardPage> createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  final List<TextEditingController> _controllers = [TextEditingController()];
  final List<FocusNode> _focusNodes = [FocusNode()];
  bool _isLoading = false;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _addWordField() {
    setState(() {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    });
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isLoading = true);
    final words = _controllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      setState(() => _isLoading = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos uma palavra.')),
      );
      return;
    }

    try {
      final created = await flashcardApi.createFlashcards(words);
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text('${created.length} flashcards criados com sucesso.'),
        ),
      );

      Navigator.of(context).pop(created.isNotEmpty);
    } on ApiException catch (e) {
      // erro da API
      messenger.showSnackBar(
        SnackBar(content: Text(e.message), behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Flashcard')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primary),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Adicione novas palavras para gerar flashcards.',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Digite uma palavra por linha e deixe que o Peixe Babel complete o resto para você.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 320,
                          child: ListView.separated(
                            itemCount: _controllers.length + 1,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              if (index == _controllers.length) {
                                return OutlinedButton.icon(
                                  onPressed: _addWordField,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Adicionar outra palavra'),
                                );
                              }

                              return TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) {
                                  if (index == _controllers.length - 1) {
                                    _addWordField();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          _focusNodes.last.requestFocus();
                                        });
                                  } else {
                                    _focusNodes[index + 1].requestFocus();
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Palavra ${index + 1}',
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Criar flashcards'),
                        ),
                      ],
                    ),
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
