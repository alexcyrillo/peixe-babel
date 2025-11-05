import 'package:flutter/material.dart';
import 'package:peixe_babel/services/api/chat_api.dart';
import 'package:peixe_babel/theme/app_theme.dart';

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
  bool _isLoadingHistory = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Widget _buildMessagesList() {
    if (_isLoadingHistory && _messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_messages.isEmpty) {
      return ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(32),
        physics: const BouncingScrollPhysics(),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Comece a conversa enviando sua primeira mensagem.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
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

        final Color bubbleColor = isUser
            ? AppColors.primaryAccent
            : AppColors.deepBlue.withOpacity(0.9);
        final Color textColor = isUser ? AppColors.textPrimary : Colors.white;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepBlue.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                    Text(entry.message, style: TextStyle(color: textColor)),
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
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoadingHistory = true);

    try {
      final history = await chatApi.fetchMessages();
      if (!mounted) {
        return;
      }

      final entries = <_ChatEntry>[];
      for (final item in history) {
        final createdAtString = item['created_at']?.toString();
        final createdAt =
            DateTime.tryParse(createdAtString ?? '') ?? DateTime.now();

        final userMessage = item['user_message']?.toString().trim();
        final agentMessage = item['agent_message']?.toString().trim();

        if (userMessage != null && userMessage.isNotEmpty) {
          entries.add(
            _ChatEntry(
              role: ChatRole.user,
              message: userMessage,
              createdAt: createdAt,
            ),
          );
        }

        if (agentMessage != null && agentMessage.isNotEmpty) {
          entries.add(
            _ChatEntry(
              role: ChatRole.agent,
              message: agentMessage,
              createdAt: createdAt,
            ),
          );
        }
      }

      setState(() {
        _messages
          ..clear()
          ..addAll(entries);
        _isLoadingHistory = false;
      });
      _scrollToBottom();
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() => _isLoadingHistory = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
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
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primary),
        child: Column(
          children: [
            Expanded(child: _buildMessagesList()),
            Container(
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
              ),
            ),
          ],
        ),
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
