import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Call state enum
enum CallState { idle, calling, connected, disconnecting, disconnected }

/// Call state provider
final callStateProvider = StateProvider<CallState>((ref) => CallState.idle);
