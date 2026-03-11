import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/chat_socket_datasource.dart';
import '../models/chat_message_model.dart';

/// Chat repository
class ChatRepository {
  final ChatSocketDataSource _socketDataSource;

  ChatRepository(this._socketDataSource);

  void subscribeToChats(String roomId, Function(ChatMessageModel) callback) {
    _socketDataSource.subscribeToChats(roomId, callback);
  }

  void sendMessage(String roomId, String message) {
    _socketDataSource.sendMessage(roomId, message);
  }
}

/// Provider for chat repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final socketDataSource = ref.watch(chatSocketDataSourceProvider);
  return ChatRepository(socketDataSource);
});
