import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/call_socket_datasource.dart';
import '../models/signaling_message_model.dart';

/// Call repository
class CallRepository {
  final CallSocketDataSource _socketDataSource;

  CallRepository(this._socketDataSource);

  void subscribeToCallSignals(
    String callId,
    Function(SignalingMessageModel) callback,
  ) {
    _socketDataSource.subscribeToCallSignals(callId, callback);
  }

  void sendSignal(SignalingMessageModel message) {
    _socketDataSource.sendSignal(message);
  }
}

/// Provider for call repository
final callRepositoryProvider = Provider<CallRepository>((ref) {
  final socketDataSource = ref.watch(callSocketDataSourceProvider);
  return CallRepository(socketDataSource);
});
