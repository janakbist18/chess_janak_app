import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message_model.dart';
import '../../../core/websocket/socket_client.dart';
import '../../../core/websocket/socket_message.dart';

/// Chat socket data source
class ChatSocketDataSource {
  final SocketClient _socketClient;

  ChatSocketDataSource(this._socketClient);

  void subscribeToChats(String roomId, Function(ChatMessageModel) callback) {
    _socketClient.on((message) {
      if (message.type == 'chat_message') {
        final data = message.payload['message'] as Map<String, dynamic>;
        callback(ChatMessageModel.fromJson(data));
      }
    });
  }

  void sendMessage(String roomId, String message) {
    final socketMessage = SocketMessage(
      type: 'chat_message',
      payload: {'roomId': roomId, 'message': message},
    );
    _socketClient.send(socketMessage);
  }
}

/// Provider for chat socket data source
final chatSocketDataSourceProvider = Provider<ChatSocketDataSource>((ref) {
  final socketClient = ref.watch(socketClientProvider);
  return ChatSocketDataSource(socketClient);
});
