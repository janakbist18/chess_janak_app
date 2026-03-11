/// Signaling message model for WebRTC
class SignalingMessageModel {
  final String type;
  final String from;
  final String to;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  SignalingMessageModel({
    required this.type,
    required this.from,
    required this.to,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory SignalingMessageModel.fromJson(Map<String, dynamic> json) {
    return SignalingMessageModel(
      type: json['type'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      data: json['data'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'from': from,
    'to': to,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };
}
