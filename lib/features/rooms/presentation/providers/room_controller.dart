import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/room_model.dart';
import '../../data/repositories/rooms_repository.dart';

/// Room controller
class RoomController extends StateNotifier<RoomModel?> {
  final RoomsRepository _repository;

  RoomController(this._repository) : super(null);

  Future<void> getRoomDetails(String roomId) async {
    try {
      final room = await _repository.getRoomDetails(roomId);
      state = room;
    } catch (e) {
      state = null;
    }
  }
}

/// Provider for room controller
final roomControllerProvider =
    StateNotifierProvider<RoomController, RoomModel?>((ref) {
      final repository = ref.watch(roomsRepositoryProvider);
      return RoomController(repository);
    });
