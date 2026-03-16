import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';

/// Chat controller
class ChatController extends StateNotifier<List<ChatMessageModel>> {
  final ChatRepository _repository;

  ChatController(this._repository) : super([]);

  void subscribeToChat(String roomId) {
    _repository.subscribeToChats(roomId, (message) {
      state = [...state, message];
    });
  }

  void sendMessage(String roomId, String message) {
    _repository.sendMessage(roomId, message);
  }
}

/// Provider for chat controller
final chatControllerProvider =
    StateNotifierProvider<ChatController, List<ChatMessageModel>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatController(repository);
});
