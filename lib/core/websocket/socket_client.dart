import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'socket_message.dart';
import 'socket_state.dart';

/// WebSocket client for real-time communication
class SocketClient {
  SocketState _state = SocketState.disconnected;
  final List<Function(SocketMessage)> _listeners = [];

  SocketState get state => _state;

  /// Connect to WebSocket server
  Future<void> connect(String url) async {
    _state = SocketState.connecting;
    try {
      // TODO: Implement actual WebSocket connection
      // This is a placeholder implementation
      _state = SocketState.connected;
      _notifyListeners(
        SocketMessage(
          type: 'connection_established',
          payload: {'message': 'Connected to server'},
        ),
      );
    } catch (e) {
      _state = SocketState.error;
      throw Exception('Connection failed: $e');
    }
  }

  /// Disconnect from WebSocket server
  Future<void> disconnect() async {
    _state = SocketState.disconnected;
    _listeners.clear();
  }

  /// Send a message through WebSocket
  void send(SocketMessage message) {
    if (!_state.isConnected) {
      throw Exception('WebSocket is not connected');
    }
    // TODO: Implement actual send logic
  }

  /// Listen for incoming messages
  void on(Function(SocketMessage) callback) {
    _listeners.add(callback);
  }

  /// Stop listening for messages
  void off(Function(SocketMessage) callback) {
    _listeners.remove(callback);
  }

  void _notifyListeners(SocketMessage message) {
    for (final listener in _listeners) {
      listener(message);
    }
  }

  /// Check if connected
  bool get isConnected => _state.isConnected;
}

/// Provider for WebSocket client
final socketClientProvider = Provider<SocketClient>((ref) {
  return SocketClient();
});
