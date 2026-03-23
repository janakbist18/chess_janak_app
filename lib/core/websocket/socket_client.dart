import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import 'dart:convert';
import 'socket_message.dart';
import 'socket_state.dart';

/// WebSocket client for real-time communication
class SocketClient {
  SocketState _state = SocketState.disconnected;
  final List<Function(SocketMessage)> _listeners = [];
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final Duration reconnectDelay = const Duration(seconds: 5);
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;

  SocketState get state => _state;
  bool get isConnected => _state.isConnected;

  /// Connect to WebSocket server
  Future<void> connect(String url, {String? token}) async {
    if (_state.isConnected) return;

    _state = SocketState.connecting;
    try {
      // Construct WebSocket URL with authentication
      final wsUrl = Uri.parse(url);
      final wsUrlWithToken = token != null
          ? wsUrl.replace(queryParameters: {'token': token}).toString()
          : url;

      _channel = WebSocketChannel.connect(Uri.parse(wsUrlWithToken));

      // Listen to incoming messages
      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDone,
      );

      _state = SocketState.connected;
      _reconnectAttempts = 0;

      _notifyListeners(
        SocketMessage(
          type: 'connection_established',
          payload: {'message': 'Connected to server'},
        ),
      );
    } catch (e) {
      _state = SocketState.error;
      _attemptReconnect(url, token);
    }
  }

  /// Disconnect from WebSocket server
  Future<void> disconnect() async {
    _state = SocketState.disconnected;
    _reconnectAttempts = _maxReconnectAttempts; // Prevent auto reconnect
    await _subscription?.cancel();
    await _channel?.sink.close();
    _listeners.clear();
  }

  /// Send a message through WebSocket
  void send(SocketMessage message) {
    if (!_state.isConnected) {
      print('WebSocket is not connected');
      return;
    }
    try {
      _channel?.sink.add(jsonEncode(message.toJson()));
    } catch (e) {
      print('Error sending message: $e');
    }
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

  /// Handle incoming messages
  void _handleMessage(dynamic message) {
    try {
      if (message is String) {
        final json = jsonDecode(message) as Map<String, dynamic>;
        final socketMessage = SocketMessage.fromJson(json);
        _notifyListeners(socketMessage);
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  /// Handle connection errors
  void _handleError(error) {
    print('WebSocket error: $error');
    _state = SocketState.error;
    _notifyListeners(
      SocketMessage(
        type: 'error',
        payload: {'message': error.toString()},
      ),
    );
  }

  /// Handle connection closed
  void _handleDone() {
    _state = SocketState.disconnected;
    print('WebSocket connection closed');
    _notifyListeners(
      SocketMessage(
        type: 'connection_closed',
        payload: {'message': 'Connection closed'},
      ),
    );
  }

  /// Attempt to reconnect with exponential backoff
  Future<void> _attemptReconnect(String url, String? token) async {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _state = SocketState.error;
      _notifyListeners(
        SocketMessage(
          type: 'connection_failed',
          payload: {
            'message': 'Failed to connect after $_maxReconnectAttempts attempts'
          },
        ),
      );
      return;
    }

    _reconnectAttempts++;
    final delay = reconnectDelay * _reconnectAttempts;

    print('Reconnecting in ${delay.inSeconds}s...');
    await Future.delayed(delay);

    await connect(url, token: token);
  }

  /// Dispose resources
  void dispose() {
    disconnect();
  }
}

/// Provider for WebSocket client
final socketClientProvider = Provider<SocketClient>((ref) {
  return SocketClient();
});
