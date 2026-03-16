import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/chat_message_model.dart';

/// Chat conversation with a specific user
class ChatConversation {
  final String conversationId;
  final String recipientId;
  final String recipientName;
  final String? recipientImage;
  final List<ChatMessageModel> messages;
  final DateTime lastMessageAt;
  final int unreadCount;

  ChatConversation({
    required this.conversationId,
    required this.recipientId,
    required this.recipientName,
    this.recipientImage,
    required this.messages,
    required this.lastMessageAt,
    this.unreadCount = 0,
  });

  ChatConversation copyWith({
    String? conversationId,
    String? recipientId,
    String? recipientName,
    String? recipientImage,
    List<ChatMessageModel>? messages,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return ChatConversation(
      conversationId: conversationId ?? this.conversationId,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      recipientImage: recipientImage ?? this.recipientImage,
      messages: messages ?? this.messages,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

/// Notifier for managing general chat conversations
class ChatNotifier extends StateNotifier<List<ChatConversation>> {
  final String _currentUserId;
  final String _currentUserName;
  final String? _currentUserImage;

  ChatNotifier({
    required String currentUserId,
    required String currentUserName,
    String? currentUserImage,
  })  : _currentUserId = currentUserId,
        _currentUserName = currentUserName,
        _currentUserImage = currentUserImage,
        super([]);

  /// Public getter for current user ID
  String get currentUserId => _currentUserId;

  /// Open or get existing conversation with a user
  void openConversation(String userId, String userName, String? userImage) {
    try {
      final existingIndex = state.indexWhere(
        (conv) => conv.recipientId == userId,
      );

      if (existingIndex >= 0) {
        // Move to top
        final conversation = state.removeAt(existingIndex);
        state = [conversation, ...state];
      } else {
        // Create new conversation
        final newConversation = ChatConversation(
          conversationId: '${_currentUserId}_$userId',
          recipientId: userId,
          recipientName: userName,
          recipientImage: userImage,
          messages: [],
          lastMessageAt: DateTime.now(),
          unreadCount: 0,
        );
        state = [newConversation, ...state];
      }
    } catch (e) {
      print('Error opening conversation: $e');
    }
  }

  /// Send message in conversation
  void sendMessage(String recipientId, String messageText) {
    try {
      final convIndex = state.indexWhere(
        (conv) => conv.recipientId == recipientId,
      );

      if (convIndex < 0) return;

      final conversation = state[convIndex];
      final newMessage = ChatMessageModel(
        id: '$_currentUserId-${DateTime.now().millisecondsSinceEpoch}',
        senderId: _currentUserId,
        senderName: _currentUserName,
        senderImage: _currentUserImage,
        message: messageText,
        sentAt: DateTime.now(),
        isRead: true,
      );

      final updatedConversation = conversation.copyWith(
        messages: [...conversation.messages, newMessage],
        lastMessageAt: DateTime.now(),
      );

      state = [
        updatedConversation,
        ...state.sublist(0, convIndex),
        ...state.sublist(convIndex + 1),
      ];
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  /// Receive message in conversation
  void receiveMessage(
    String senderId,
    String senderName,
    String? senderImage,
    String messageText,
  ) {
    try {
      final convIndex = state.indexWhere(
        (conv) => conv.recipientId == senderId,
      );

      if (convIndex < 0) {
        // Create new conversation if not exists
        openConversation(senderId, senderName, senderImage);
        return receiveMessage(senderId, senderName, senderImage, messageText);
      }

      final conversation = state[convIndex];
      final newMessage = ChatMessageModel(
        id: '$senderId-${DateTime.now().millisecondsSinceEpoch}',
        senderId: senderId,
        senderName: senderName,
        senderImage: senderImage,
        message: messageText,
        sentAt: DateTime.now(),
        isRead: false,
      );

      final updatedConversation = conversation.copyWith(
        messages: [...conversation.messages, newMessage],
        lastMessageAt: DateTime.now(),
        unreadCount: conversation.unreadCount + 1,
      );

      // Move conversation to top
      state = [
        updatedConversation,
        ...state.sublist(0, convIndex),
        ...state.sublist(convIndex + 1),
      ];
    } catch (e) {
      print('Error receiving message: $e');
    }
  }

  /// Mark conversation as read
  void markConversationAsRead(String recipientId) {
    try {
      final convIndex = state.indexWhere(
        (conv) => conv.recipientId == recipientId,
      );

      if (convIndex < 0) return;

      final conversation = state[convIndex];
      final updatedMessages = conversation.messages
          .map(
            (msg) => msg.senderId != _currentUserId
                ? ChatMessageModel(
                    id: msg.id,
                    senderId: msg.senderId,
                    senderName: msg.senderName,
                    senderImage: msg.senderImage,
                    message: msg.message,
                    sentAt: msg.sentAt,
                    isRead: true,
                  )
                : msg,
          )
          .toList();

      final updatedConversation = conversation.copyWith(
        messages: updatedMessages,
        unreadCount: 0,
      );

      state[convIndex] = updatedConversation;
      state = [...state]; // Notify listeners
    } catch (e) {
      print('Error marking conversation as read: $e');
    }
  }

  /// Delete conversation
  void deleteConversation(String recipientId) {
    state = state.where((conv) => conv.recipientId != recipientId).toList();
  }

  /// Get total unread count
  int getTotalUnreadCount() {
    return state.fold<int>(0, (sum, conv) => sum + conv.unreadCount);
  }

  /// Search conversations by recipient name or message content
  List<ChatConversation> searchConversations(String query) {
    if (query.trim().isEmpty) return state;

    final lowercaseQuery = query.toLowerCase();
    return state
        .where(
          (conv) =>
              conv.recipientName.toLowerCase().contains(lowercaseQuery) ||
              conv.messages.any(
                (msg) => msg.message.toLowerCase().contains(lowercaseQuery),
              ),
        )
        .toList();
  }
}

/// Provider for general chat conversations
final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatConversation>>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return ChatNotifier(
          currentUserId: '',
          currentUserName: 'Unknown',
          currentUserImage: null,
        );
      }
      return ChatNotifier(
        currentUserId: user.id,
        currentUserName: user.username,
        currentUserImage: user.avatarUrl,
      );
    },
    loading: () => ChatNotifier(
      currentUserId: '',
      currentUserName: 'Unknown',
      currentUserImage: null,
    ),
    error: (_, __) => ChatNotifier(
      currentUserId: '',
      currentUserName: 'Unknown',
      currentUserImage: null,
    ),
  );
});

/// Provider for selected conversation
final selectedChatConversationProvider = StateProvider<ChatConversation?>(
  (_) => null,
);

/// Provider for chat search
final chatSearchQueryProvider = StateProvider<String>((_) => '');

/// Computed provider for filtered conversations
final filteredChatsProvider = Provider<List<ChatConversation>>((ref) {
  final conversations = ref.watch(chatProvider);
  final query = ref.watch(chatSearchQueryProvider);

  if (query.isEmpty) return conversations;

  final lowercaseQuery = query.toLowerCase();
  return conversations
      .where(
        (conv) =>
            conv.recipientName.toLowerCase().contains(lowercaseQuery) ||
            conv.messages.any(
              (msg) => msg.message.toLowerCase().contains(lowercaseQuery),
            ),
      )
      .toList();
});

/// Provider for total unread messages
final unreadMessageCountProvider = Provider<int>((ref) {
  final conversations = ref.watch(chatProvider);
  return conversations.fold<int>(0, (sum, conv) => sum + conv.unreadCount);
});
