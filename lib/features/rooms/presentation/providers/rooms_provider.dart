import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for user's active rooms (games)
final userRoomsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // TODO: Implement getUserRooms when chess datasource is available
  return [];
});

/// Provider to manually refresh rooms list
final refreshRoomsProvider =
    Provider.family<Future<void>, void>((ref, _) async {
  ref.invalidate(userRoomsProvider);
});

/// Provider for creating a room
final createRoomProvider = FutureProvider.family<Map<String, dynamic>,
    ({String gameMode, int? timeLimit})>((ref, args) async {
  // TODO: Implement createRoom when chess datasource is available
  return {};
});

/// Provider for joining a room
final joinRoomProvider =
    FutureProvider.family<bool, String>((ref, inviteCode) async {
  // TODO: Implement joinRoom when chess datasource is available
  return false;
});

/// Provider for getting room details
final roomDetailsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, roomId) async {
  // TODO: Implement getRoomDetails when chess datasource is available
  return {};
});

/// Provider for looking up invite codes
final inviteLookupProvider =
    FutureProvider.family<Map<String, dynamic>, String>(
        (ref, inviteCode) async {
  // TODO: Implement lookupInvite when chess datasource is available
  return {};
});

/// Get room invite code from room details
final roomInviteCodeProvider =
    Provider.family<String?, Map<String, dynamic>>((ref, roomData) {
  return roomData['invite_code'] as String?;
});

/// Check if room is waiting for opponent
final isRoomWaitingProvider =
    Provider.family<bool, Map<String, dynamic>>((ref, roomData) {
  return (roomData['status'] as String?) == 'waiting';
});

/// Get opponent info from room
final opponentProvider =
    Provider.family<Map<String, dynamic>?, Map<String, dynamic>>(
        (ref, roomData) {
  final currentPlayerId = ref.watch(currentPlayerIdProvider);

  final whitePd = roomData['white_player'] as Map<String, dynamic>?;
  final blackPd = roomData['black_player'] as Map<String, dynamic>?;

  if (currentPlayerId == null) return null;

  // Return opponent (not current player)
  if (whitePd?['id'] == currentPlayerId) {
    return blackPd;
  } else {
    return whitePd;
  }
});

/// Get current player's color
final playerColorProvider =
    Provider.family<String?, Map<String, dynamic>>((ref, roomData) {
  final currentPlayerId = ref.watch(currentPlayerIdProvider);

  if (currentPlayerId == null) return null;

  final whitePd = roomData['white_player'] as Map<String, dynamic>?;

  if (whitePd?['id'] == currentPlayerId) {
    return 'white';
  } else {
    return 'black';
  }
});

/// Get current player ID (from auth provider)
final currentPlayerIdProvider = Provider<String?>((ref) {
  // This assumes you have an auth provider
  // Adjust this to match your actual auth provider
  return null; // TODO: Get from authStateProvider
});
