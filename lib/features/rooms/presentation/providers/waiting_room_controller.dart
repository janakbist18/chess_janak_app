import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/rooms_repository.dart';

/// Waiting room controller
class WaitingRoomController extends StateNotifier<bool> {
  final RoomsRepository _repository;

  WaitingRoomController(this._repository) : super(false);

  Future<void> leaveRoom(String roomId) async {
    try {
      await _repository.leaveRoom(roomId);
      state = true;
    } catch (e) {
      state = false;
    }
  }
}

/// Provider for waiting room controller
final waitingRoomControllerProvider =
    StateNotifierProvider<WaitingRoomController, bool>((ref) {
  final repository = ref.watch(roomsRepositoryProvider);
  return WaitingRoomController(repository);
});
