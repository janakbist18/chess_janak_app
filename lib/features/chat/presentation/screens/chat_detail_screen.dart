import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';

/// Chat conversation detail screen
class ChatDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String recipientId;
  final String recipientName;
  final String? recipientImage;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.recipientId,
    required this.recipientName,
    this.recipientImage,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mark conversation as read when opening
    Future.microtask(() {
      ref
          .read(chatProvider.notifier)
          .markConversationAsRead(widget.recipientId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    ref
        .read(chatProvider.notifier)
        .sendMessage(widget.recipientId, _messageController.text.trim());
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(chatProvider);
    ChatConversation? conversation;
    try {
      conversation = conversations.firstWhere(
        (c) => c.recipientId == widget.recipientId,
      );
    } catch (e) {
      conversation = null;
    }

    if (conversation == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.recipientName), centerTitle: true),
        body: const Center(child: Text('Conversation not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.recipientName),
            Text('Online', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('Clear Chat')),
              const PopupMenuItem(child: Text('Block User')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: conversation.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: conversation.messages.length,
                    itemBuilder: (context, index) {
                      final message = conversation!.messages[index];
                      final isSentByUser = message.senderId ==
                          ref.read(chatProvider.notifier).currentUserId;

                      return _MessageBubble(
                        message: message.message,
                        senderName: message.senderName,
                        isSentByCurrentUser: isSentByUser,
                        sentAt: message.sentAt,
                      );
                    },
                  ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    minLines: 1,
                    maxLength: 500,
                    onSubmitted: (_) => _handleSendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton.small(
                  onPressed: _handleSendMessage,
                  backgroundColor: Colors.amber[700],
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual message bubble widget
class _MessageBubble extends StatelessWidget {
  final String message;
  final String senderName;
  final bool isSentByCurrentUser;
  final DateTime sentAt;

  const _MessageBubble({
    required this.message,
    required this.senderName,
    required this.isSentByCurrentUser,
    required this.sentAt,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Align(
      alignment:
          isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSentByCurrentUser ? Colors.amber[700] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isSentByCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isSentByCurrentUser)
              Text(
                senderName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber,
                ),
              ),
            if (!isSentByCurrentUser) const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                color: isSentByCurrentUser ? Colors.white : Colors.black,
                fontSize: 15,
              ),
              softWrap: true,
            ),
            const SizedBox(height: 4),
            Text(
              timeFormat.format(sentAt),
              style: TextStyle(
                fontSize: 11,
                color: isSentByCurrentUser
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
