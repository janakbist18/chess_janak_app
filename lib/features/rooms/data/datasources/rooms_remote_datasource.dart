import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room_model.dart';
import '../models/create_room_response_model.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/config/api_endpoints.dart';

/// Rooms remote data source
class RoomsRemoteDataSource {
  final Dio _dio;

  RoomsRemoteDataSource(this._dio);

  Future<CreateRoomResponseModel> createRoom(
    String name, {
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createRoom,
        data: {
          'name': name,
          if (description != null) 'description': description,
        },
      );
      return CreateRoomResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<RoomModel> joinRoom(String roomId, {String? inviteCode}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.joinRoom,
        data: {
          'room_id': roomId,
          if (inviteCode != null) 'invite_code': inviteCode,
        },
      );
      return RoomModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<RoomModel> getRoom(String roomId) async {
    try {
      final response = await _dio.get(ApiEndpoints.roomDetail(roomId));
      return RoomModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RoomModel>> getRooms() async {
    try {
      final response = await _dio.get(ApiEndpoints.myRooms);
      final data = response.data is List
          ? response.data as List<dynamic>
          : (response.data['results'] ?? []) as List<dynamic>;
      return data
          .map((room) => RoomModel.fromJson(room as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> leaveRoom(String roomId) async {
    try {
      await _dio.post('${ApiEndpoints.roomDetail(roomId)}leave/');
    } catch (e) {
      rethrow;
    }
  }
}

/// Provider for rooms remote data source
final roomsRemoteDataSourceProvider = Provider<RoomsRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return RoomsRemoteDataSource(dio);
});
