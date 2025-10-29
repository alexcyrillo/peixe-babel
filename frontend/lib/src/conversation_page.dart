import 'package:flutter/material.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversa com IA')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Tela dedicada à conversa em inglês com o agente conectado à API.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
