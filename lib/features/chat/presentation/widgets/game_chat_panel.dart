import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/game_chat_provider.dart';

/// In-game chat panel widget
class GameChatPanel extends ConsumerStatefulWidget {
  final String roomId;
  final bool isCompact;

  const GameChatPanel({
    super.key,
    required this.roomId,
    this.isCompact = false,
  });

  @override
  ConsumerState<GameChatPanel> createState() => _GameChatPanelState();
}

class _GameChatPanelState extends ConsumerState<GameChatPanel> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late ScrollController _autoScrollController;

  @override
  void initState() {
    super.initState();
    _autoScrollController = ScrollController();
  }

  @override
  void didUpdateWidget(GameChatPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final autoScroll = ref.read(chatAutoScrollProvider);
      if (autoScroll &&
          _autoScrollController.hasClients &&
          _autoScrollController.position.maxScrollExtent > 0) {
        _autoScrollController.animateTo(
          _autoScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      ref
          .read(gameChatProvider(widget.roomId).notifier)
          .sendMessage(_messageController.text.trim());
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _autoScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(gameChatProvider(widget.roomId));
    final isVisible = ref.watch(chatVisibilityProvider);

    if (!isVisible) {
      return _buildChatToggleButton(context, messages.length);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade700, width: 1.5),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Game Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (!widget.isCompact)
                  IconButton(
                    icon: const Icon(
                      Icons.expand_less,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      ref.read(chatVisibilityProvider.notifier).state = false;
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
          // Messages list
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _autoScrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _GameChatBubble(
                        message: messages[index],
                        index: index,
                      );
                    },
                  ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[700]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: null,
                    minLines: 1,
                    maxLength: 500,
                    onSubmitted: (_) => _handleSendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Type message...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.amber.shade700,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[900],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: _handleSendMessage,
                  backgroundColor: Colors.amber.shade700,
                  child: const Icon(Icons.send, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatToggleButton(BuildContext context, int messageCount) {
    return FloatingActionButton.small(
      onPressed: () {
        ref.read(chatVisibilityProvider.notifier).state = true;
      },
      backgroundColor: Colors.amber.shade700,
      child: Badge(
        label: Text(messageCount.toString()),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}

/// Individual chat message bubble
class _GameChatBubble extends StatelessWidget {
  final dynamic message;
  final int index;

  const _GameChatBubble({required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    final isSentByUser = message.isSentByCurrentUser;
    final timeFormat = DateFormat('HH:mm');

    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.amber.shade700 : Colors.grey[700],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment:
              isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender name (only show if not sent by user)
            if (!isSentByUser)
              Text(
                message.senderName,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber,
                ),
              ),
            if (!isSentByUser) const SizedBox(height: 2),
            // Message text
            Text(
              message.message,
              style: TextStyle(
                color: isSentByUser ? Colors.white : Colors.white,
                fontSize: 14,
              ),
              softWrap: true,
            ),
            const SizedBox(height: 2),
            // Time
            Text(
              timeFormat.format(message.sentAt),
              style: TextStyle(
                fontSize: 10,
                color: isSentByUser
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
