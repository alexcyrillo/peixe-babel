import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Revisão')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Aqui ficará o fluxo de revisão dos flashcards conectados à API.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
