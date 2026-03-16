import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../chess/presentation/providers/game_websocket_provider.dart';

/// Game Chat Message with sender info
class GameChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String message;
  final DateTime sentAt;
  final bool isSentByCurrentUser;

  GameChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.message,
    required this.sentAt,
    this.isSentByCurrentUser = false,
  });

  factory GameChatMessage.fromUpdate(
    String currentUserId,
    Map<String, dynamic> data,
  ) {
    final senderId = data['sender_id'] as String;
    return GameChatMessage(
      id: data['id'] as String? ?? '$senderId-${data['timestamp']}',
      senderId: senderId,
      senderName: data['sender_name'] as String? ?? 'Player',
      senderImage: data['sender_image'] as String?,
      message: data['message'] as String,
      sentAt: DateTime.parse(
        data['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      ),
      isSentByCurrentUser: senderId == currentUserId,
    );
  }
}

/// Notifier for managing game chat messages
class GameChatNotifier extends StateNotifier<List<GameChatMessage>> {
  final String _currentUserId;
  final Ref _ref;

  GameChatNotifier({
    required String currentUserId,
    required Ref ref,
  })  : _currentUserId = currentUserId,
        _ref = ref,
        super([]) {
    _initializeChatListener();
  }

  void _initializeChatListener() {
    // Listen to WebSocket updates for chat messages
    _ref.listen<AsyncValue<GameUpdate?>>(gameWebSocketProvider, (
      previous,
      next,
    ) {
      next.whenData((update) {
        if (update != null &&
            (update.type == 'chat' || update.type == 'chat_message')) {
          _handleChatMessage(update.data);
        }
      });
    });
  }

  void _handleChatMessage(Map<String, dynamic> data) {
    try {
      final message = GameChatMessage.fromUpdate(_currentUserId, data);
      state = [...state, message];
    } catch (e) {
      print('Error parsing chat message: $e');
    }
  }

  /// Send a chat message during the game
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      // Get current user for sending message
      final authState = _ref.read(authStateProvider);
      final userName = authState.value?.username ?? 'Player';
      final userImage = authState.value?.avatarUrl;

      // Create local message for immediate UI display
      final localMessage = GameChatMessage(
        id: '$_currentUserId-${DateTime.now().millisecondsSinceEpoch}',
        senderId: _currentUserId,
        senderName: userName,
        senderImage: userImage,
        message: message,
        sentAt: DateTime.now(),
        isSentByCurrentUser: true,
      );

      // Add to local state immediately for better UX
      state = [...state, localMessage];

      // Send via WebSocket
      final webSocketNotifier = _ref.read(gameWebSocketProvider.notifier);
      webSocketNotifier.sendChatMessage(message);
    } catch (e) {
      print('Error sending chat message: $e');
      // Remove the message if sending failed
      if (state.isNotEmpty) {
        state = state.sublist(0, state.length - 1);
      }
    }
  }

  /// Clear chat history (useful when game resets)
  void clearMessages() {
    state = [];
  }

  /// Get unread message count
  int getUnreadCount() {
    return state.where((msg) => !msg.isSentByCurrentUser).length;
  }
}

/// Provider for managing game chat
final gameChatProvider = StateNotifierProvider.family<GameChatNotifier,
    List<GameChatMessage>, String>((ref, roomId) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return GameChatNotifier(
          currentUserId: '',
          ref: ref,
        );
      }
      return GameChatNotifier(
        currentUserId: user.id,
        ref: ref,
      );
    },
    loading: () => GameChatNotifier(currentUserId: '', ref: ref),
    error: (_, __) => GameChatNotifier(currentUserId: '', ref: ref),
  );
});

/// Provider for tracking chat visibility in game (collapsed/expanded)
final chatVisibilityProvider = StateProvider<bool>((ref) => true);

/// Provider for chat auto-scroll state
final chatAutoScrollProvider = StateProvider<bool>((ref) => true);
