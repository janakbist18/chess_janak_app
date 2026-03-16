import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';

/// Model for real-time game updates
class GameUpdate {
  final String type; // 'move', 'check', 'checkmate', 'draw', 'resignation'
  final Map<String, dynamic> data;
  final DateTime timestamp;

  GameUpdate({required this.type, required this.data, required this.timestamp});

  factory GameUpdate.fromJson(Map<String, dynamic> json) {
    return GameUpdate(
      type: json['type'] ?? '',
      data: json['data'] ?? {},
      timestamp: DateTime.now(),
    );
  }
}

/// WebSocket provider for real-time game updates
final gameWebSocketProvider =
    StateNotifierProvider<GameWebSocketNotifier, AsyncValue<GameUpdate?>>((
      ref,
    ) {
      return GameWebSocketNotifier();
    });

/// Manages WebSocket connections for game updates
class GameWebSocketNotifier extends StateNotifier<AsyncValue<GameUpdate?>> {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  String? _currentRoomId;

  GameWebSocketNotifier() : super(const AsyncValue.data(null));

  /// Connect to game room WebSocket
  Future<void> connectToGame(String roomId, String token) async {
    _currentRoomId = roomId;
    state = const AsyncValue.loading();

    try {
      // Connect to Django Channels WebSocket
      final wsUrl = Uri.parse(
        'ws://10.0.2.2:8000/ws/room/$roomId/?token=$token',
      );

      _channel = WebSocketChannel.connect(wsUrl);

      // Listen for messages
      _subscription = _channel!.stream.listen(
        (message) {
          try {
            final json = jsonDecode(message);
            final update = GameUpdate.fromJson(json);
            state = AsyncValue.data(update);
          } catch (e) {
            print('Error parsing game update: $e');
          }
        },
        onError: (error) {
          state = AsyncValue.error(error, StackTrace.current);
        },
        onDone: () {
          print('WebSocket connection closed for room: $roomId');
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Send a move to the server
  void sendMove(String from, String to, {String? promotion}) {
    if (_channel == null) return;

    final moveData = {
      'type': 'move',
      'from': from,
      'to': to,
      if (promotion != null) 'promotion': promotion,
    };

    _channel!.sink.add(jsonEncode(moveData));
  }

  /// Send a chat message
  void sendChatMessage(String message) {
    if (_channel == null) return;

    final messageData = {'type': 'chat', 'message': message};

    _channel!.sink.add(jsonEncode(messageData));
  }

  /// Send resignation
  void resign() {
    if (_channel == null) return;

    final resignData = {'type': 'resignation'};

    _channel!.sink.add(jsonEncode(resignData));
  }

  /// Send draw offer
  void offerDraw() {
    if (_channel == null) return;

    final drawData = {'type': 'draw_offer'};

    _channel!.sink.add(jsonEncode(drawData));
  }

  /// Accept draw
  void acceptDraw() {
    if (_channel == null) return;

    final drawData = {'type': 'accept_draw'};

    _channel!.sink.add(jsonEncode(drawData));
  }

  /// Decline draw
  void declineDraw() {
    if (_channel == null) return;

    final drawData = {'type': 'decline_draw'};

    _channel!.sink.add(jsonEncode(drawData));
  }

  /// Disconnect from game
  Future<void> disconnect() async {
    await _subscription?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _currentRoomId = null;
    state = const AsyncValue.data(null);
  }

  /// Check if connected
  bool get isConnected => _channel != null && _currentRoomId != null;
}
