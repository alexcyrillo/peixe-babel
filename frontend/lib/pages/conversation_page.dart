import 'package:flutter/material.dart';
import 'package:peixe_babel/services/api/chat_api.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final List<_ChatEntry> _messages = <_ChatEntry>[];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSending = false;
  bool _awaitingAgent = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_isSending) {
      return;
    }

    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    final userEntry = _ChatEntry(
      role: ChatRole.user,
      message: text,
      createdAt: DateTime.now(),
    );

    setState(() {
      _messages.add(userEntry);
      _isSending = true;
      _awaitingAgent = true;
      _messageController.clear();
    });
    _scrollToBottom();

    try {
      final response = await chatApi.sendMessage(text);
      final agentMessage = response['agent_message']?.toString() ?? '';
      final createdAtString = response['created_at']?.toString();
      final createdAt =
          DateTime.tryParse(createdAtString ?? '') ?? DateTime.now();

      if (!mounted) {
        return;
      }

      setState(() {
        _messages.add(
          _ChatEntry(
            role: ChatRole.agent,
            message: agentMessage.isNotEmpty
                ? agentMessage
                : 'O agente não retornou uma mensagem.',
            createdAt: createdAt,
          ),
        );
        _awaitingAgent = false;
        _isSending = false;
      });
      _scrollToBottom();
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _awaitingAgent = false;
        _isSending = false;
      });

      _messageController.text = text;
      _messageController.selection = TextSelection.collapsed(
        offset: _messageController.text.length,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      final position = _scrollController.position;
      _scrollController.animateTo(
        position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversa com IA')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_awaitingAgent ? 1 : 0),
              itemBuilder: (context, index) {
                if (_awaitingAgent && index == _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }

                final entry = _messages[index];
                final isUser = entry.role == ChatRole.user;

                final bubbleColor = isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant;
                final textColor = isUser
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.message,
                              style: TextStyle(color: textColor),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              entry.formattedTime,
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    enabled: !_isSending,
                    decoration: const InputDecoration(
                      hintText: 'Envie uma mensagem em inglês...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isSending ? null : _sendMessage,
                  icon: const Icon(Icons.send),
                  label: const Text('Enviar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum ChatRole { user, agent }

class _ChatEntry {
  const _ChatEntry({
    required this.role,
    required this.message,
    required this.createdAt,
  });

  final ChatRole role;
  final String message;
  final DateTime createdAt;

  String get formattedTime {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
