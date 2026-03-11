/// Game state model
class GameStateModel {
  final String gameId;
  final String whitePlayerId;
  final String blackPlayerId;
  final List<String> moves;
  final String currentTurn;
  final String status;
  final String? result;
  final String? resultReason;
  final DateTime startedAt;
  final DateTime? endedAt;

  GameStateModel({
    required this.gameId,
    required this.whitePlayerId,
    required this.blackPlayerId,
    required this.moves,
    required this.currentTurn,
    required this.status,
    this.result,
    this.resultReason,
    required this.startedAt,
    this.endedAt,
  });

  factory GameStateModel.fromJson(Map<String, dynamic> json) {
    return GameStateModel(
      gameId: json['gameId'] as String,
      whitePlayerId: json['whitePlayerId'] as String,
      blackPlayerId: json['blackPlayerId'] as String,
      moves: List<String>.from(json['moves'] as List? ?? []),
      currentTurn: json['currentTurn'] as String,
      status: json['status'] as String,
      result: json['result'] as String?,
      resultReason: json['resultReason'] as String?,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'gameId': gameId,
    'whitePlayerId': whitePlayerId,
    'blackPlayerId': blackPlayerId,
    'moves': moves,
    'currentTurn': currentTurn,
    'status': status,
    'result': result,
    'resultReason': resultReason,
    'startedAt': startedAt.toIso8601String(),
    'endedAt': endedAt?.toIso8601String(),
  };
}
