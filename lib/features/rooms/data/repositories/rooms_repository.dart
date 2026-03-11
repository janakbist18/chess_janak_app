import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/rooms_remote_datasource.dart';
import '../models/room_model.dart';
import '../models/create_room_response_model.dart';

/// Rooms repository
class RoomsRepository {
  final RoomsRemoteDataSource _remoteDataSource;

  RoomsRepository(this._remoteDataSource);

  Future<CreateRoomResponseModel> createRoom(
    String name, {
    String? description,
  }) {
    return _remoteDataSource.createRoom(name, description: description);
  }

  Future<RoomModel> joinRoom(String roomId, {String? inviteCode}) {
    return _remoteDataSource.joinRoom(roomId, inviteCode: inviteCode);
  }

  Future<RoomModel> getRoom(String roomId) {
    return _remoteDataSource.getRoom(roomId);
  }

  Future<List<RoomModel>> getRooms() {
    return _remoteDataSource.getRooms();
  }

  Future<void> leaveRoom(String roomId) {
    return _remoteDataSource.leaveRoom(roomId);
  }
}

/// Provider for rooms repository
final roomsRepositoryProvider = Provider<RoomsRepository>((ref) {
  final remoteDataSource = ref.watch(roomsRemoteDataSourceProvider);
  return RoomsRepository(remoteDataSource);
});
