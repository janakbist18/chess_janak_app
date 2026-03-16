import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import 'chat_detail_screen.dart';

/// Chat list screen showing all conversations
class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openConversation(String userId, String userName, String? userImage) {
    ref
        .read(chatProvider.notifier)
        .openConversation(userId, userName, userImage);
  }

  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(filteredChatsProvider);
    final unreadCount = ref.watch(unreadMessageCountProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (unreadCount > 0)
            Center(
              child: Badge(
                label: Text(unreadCount.toString()),
                child: const SizedBox(width: 24),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref.read(chatSearchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(chatSearchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Conversations list
          Expanded(
            child: conversations.isEmpty
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
                          'No conversations',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start chatting with friends',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      final lastMessage = conversation.messages.isNotEmpty
                          ? conversation.messages.last.message
                          : 'No messages';
                      final hasUnread = conversation.unreadCount > 0;

                      return _ConversationTile(
                        conversation: conversation,
                        lastMessage: lastMessage,
                        hasUnread: hasUnread,
                        onTap: () {
                          if (isMobile) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatDetailScreen(
                                  conversationId: conversation.conversationId,
                                  recipientId: conversation.recipientId,
                                  recipientName: conversation.recipientName,
                                  recipientImage: conversation.recipientImage,
                                ),
                              ),
                            );
                          } else {
                            ref
                                    .read(
                                      selectedChatConversationProvider.notifier,
                                    )
                                    .state =
                                conversation;
                          }
                        },
                        onDelete: () {
                          ref
                              .read(chatProvider.notifier)
                              .deleteConversation(conversation.recipientId);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewConversationDialog(context);
        },
        backgroundColor: Colors.amber[700],
        child: const Icon(Icons.message),
      ),
    );
  }

  void _showNewConversationDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Conversation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter player name or ID',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _openConversation(
                  'user_${nameController.text}',
                  nameController.text,
                  null,
                );
                Navigator.pop(context);
                // Navigate to detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatDetailScreen(
                      conversationId: 'conv_user_${nameController.text}',
                      recipientId: 'user_${nameController.text}',
                      recipientName: nameController.text,
                      recipientImage: null,
                    ),
                  ),
                );
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

/// Individual conversation tile
class _ConversationTile extends StatelessWidget {
  final dynamic conversation;
  final String lastMessage;
  final bool hasUnread;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ConversationTile({
    required this.conversation,
    required this.lastMessage,
    required this.hasUnread,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final lastTime = timeFormat.format(conversation.lastMessageAt);

    return Dismissible(
      key: Key(conversation.conversationId),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber[700],
          backgroundImage: conversation.recipientImage != null
              ? NetworkImage(conversation.recipientImage!)
              : null,
          child: conversation.recipientImage == null
              ? Text(
                  conversation.recipientName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                )
              : null,
        ),
        title: Text(
          conversation.recipientName,
          style: TextStyle(
            fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: hasUnread ? Colors.black : Colors.grey[600],
            fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(lastTime, style: Theme.of(context).textTheme.labelSmall),
            if (hasUnread)
              Badge(label: Text(conversation.unreadCount.toString())),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
