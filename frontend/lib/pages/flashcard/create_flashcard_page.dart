import 'package:flutter/material.dart';
import 'package:peixe_babel/services/api/flashcard_api.dart';

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

      for (final controller in _controllers) {
        controller.clear();
      }
      if (_focusNodes.isNotEmpty) {
        _focusNodes.first.requestFocus();
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text('${created.length} flashcards criados com sucesso.'),
        ),
      );
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _controllers.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == _controllers.length) {
                    // botão logo após o último campo
                    return ElevatedButton.icon(
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
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _focusNodes.last.requestFocus();
                        });
                      } else {
                        _focusNodes[index + 1].requestFocus();
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Palavra ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }
}
