/// Chess move model
class ChessMoveModel {
  final String from;
  final String to;
  final String? promotion;
  final int moveNumber;
  final DateTime timestamp;

  ChessMoveModel({
    required this.from,
    required this.to,
    this.promotion,
    required this.moveNumber,
    required this.timestamp,
  });

  factory ChessMoveModel.fromJson(Map<String, dynamic> json) {
    return ChessMoveModel(
      from: json['from'] as String,
      to: json['to'] as String,
      promotion: json['promotion'] as String?,
      moveNumber: json['moveNumber'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'promotion': promotion,
    'moveNumber': moveNumber,
    'timestamp': timestamp.toIso8601String(),
  };
}
