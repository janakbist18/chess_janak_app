import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/call_repository.dart';
import '../../data/models/signaling_message_model.dart';

/// WebRTC call controller
class WebRtcCallController extends StateNotifier<Map<String, dynamic>> {
  final CallRepository _repository;

  WebRtcCallController(this._repository)
    : super({'callState': 'idle', 'isMuted': false, 'isVideoEnabled': true});

  void subscribe(String callId) {
    _repository.subscribeToCallSignals(callId, (message) {
      // Handle incoming signals
    });
  }

  void toggleMute() {
    state = {...state, 'isMuted': !(state['isMuted'] as bool)};
  }

  void toggleVideo() {
    state = {...state, 'isVideoEnabled': !(state['isVideoEnabled'] as bool)};
  }

  void endCall() {
    state = {...state, 'callState': 'ended'};
  }
}

/// Provider for WebRTC call controller
final webRtcCallControllerProvider =
    StateNotifierProvider<WebRtcCallController, Map<String, dynamic>>((ref) {
      final repository = ref.watch(callRepositoryProvider);
      return WebRtcCallController(repository);
    });
