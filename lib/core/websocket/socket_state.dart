/// WebSocket connection states
enum SocketState { disconnected, connecting, connected, reconnecting, error }

extension SocketStateExtension on SocketState {
  bool get isConnected => this == SocketState.connected;
  bool get isDisconnected => this == SocketState.disconnected;
  bool get isConnecting => this == SocketState.connecting;
  bool get isError => this == SocketState.error;
}
