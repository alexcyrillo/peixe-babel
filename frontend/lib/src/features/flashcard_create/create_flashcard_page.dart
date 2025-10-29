import 'package:flutter/material.dart';

class CreateFlashcardPage extends StatefulWidget {
  const CreateFlashcardPage({super.key});

  @override
  State<CreateFlashcardPage> createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  final List<TextEditingController> _controllers = [TextEditingController()];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addWordField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
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
              onPressed: () {
                final words = _controllers
                    .map((controller) => controller.text.trim())
                    .where((word) => word.isNotEmpty)
                    .toList();
                debugPrint('Palavras para criar: $words');
              },
              child: const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }
}
