import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room_model.dart';
import '../models/create_room_response_model.dart';

/// Rooms remote data source
class RoomsRemoteDataSource {
  RoomsRemoteDataSource();

  Future<CreateRoomResponseModel> createRoom(
    String name, {
    String? description,
  }) async {
    // TODO: Implement create room API call
    throw UnimplementedError();
  }

  Future<RoomModel> joinRoom(String roomId, {String? inviteCode}) async {
    // TODO: Implement join room API call
    throw UnimplementedError();
  }

  Future<RoomModel> getRoom(String roomId) async {
    // TODO: Implement get room API call
    throw UnimplementedError();
  }

  Future<List<RoomModel>> getRooms() async {
    // TODO: Implement get rooms list API call
    throw UnimplementedError();
  }

  Future<void> leaveRoom(String roomId) async {
    // TODO: Implement leave room API call
    throw UnimplementedError();
  }
}

/// Provider for rooms remote data source
final roomsRemoteDataSourceProvider = Provider<RoomsRemoteDataSource>((ref) {
  return RoomsRemoteDataSource();
});
