
/// Socket message model for WebSocket communication
class SocketMessage {
  final String type;
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  SocketMessage({
    required this.type,
    required this.payload,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory SocketMessage.fromJson(Map<String, dynamic> json) {
    return SocketMessage(
      type: json['type'] as String,
      payload: json['payload'] as Map<String, dynamic>? ?? {},
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'payload': payload,
    'timestamp': timestamp.toIso8601String(),
  };
}
