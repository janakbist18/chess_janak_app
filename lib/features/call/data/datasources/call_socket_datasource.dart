import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/signaling_message_model.dart';
import '../../../core/websocket/socket_client.dart';
import '../../../core/websocket/socket_message.dart';

/// Call socket data source
class CallSocketDataSource {
  final SocketClient _socketClient;

  CallSocketDataSource(this._socketClient);

  void subscribeToCallSignals(
    String callId,
    Function(SignalingMessageModel) callback,
  ) {
    _socketClient.on((message) {
      if (message.type == 'webrtc_signal') {
        final data = message.payload['data'] as Map<String, dynamic>;
        callback(SignalingMessageModel.fromJson(data));
      }
    });
  }

  void sendSignal(SignalingMessageModel message) {
    final socketMessage = SocketMessage(
      type: 'webrtc_signal',
      payload: {'data': message.toJson()},
    );
    _socketClient.send(socketMessage);
  }
}

/// Provider for call socket data source
final callSocketDataSourceProvider = Provider<CallSocketDataSource>((ref) {
  final socketClient = ref.watch(socketClientProvider);
  return CallSocketDataSource(socketClient);
});
