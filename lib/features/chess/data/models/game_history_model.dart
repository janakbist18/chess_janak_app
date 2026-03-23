class GameHistoryModel {
  final String gameId;
  final String whitePlayerId;
  final String blackPlayerId;
  final String whitePlayerName;
  final String blackPlayerName;
  final String? whitePlayerAvatar;
  final String? blackPlayerAvatar;
  final String result; // win, loss, draw
  final String? winnerId;
  final String endReason; // checkmate, resignation, timeout, stalemate
  final List<String> moves;
  final String gameMode;
  final int durationSeconds;
  final DateTime playedAt;

  GameHistoryModel({
    required this.gameId,
    required this.whitePlayerId,
    required this.blackPlayerId,
    required this.whitePlayerName,
    required this.blackPlayerName,
    this.whitePlayerAvatar,
    this.blackPlayerAvatar,
    required this.result,
    this.winnerId,
    required this.endReason,
    required this.moves,
    required this.gameMode,
    required this.durationSeconds,
    required this.playedAt,
  });

  factory GameHistoryModel.fromJson(Map<String, dynamic> json) {
    return GameHistoryModel(
      gameId: json['gameId'] ?? '',
      whitePlayerId: json['whitePlayerId'] ?? '',
      blackPlayerId: json['blackPlayerId'] ?? '',
      whitePlayerName: json['whitePlayerName'] ?? 'White',
      blackPlayerName: json['blackPlayerName'] ?? 'Black',
      whitePlayerAvatar: json['whitePlayerAvatar'],
      blackPlayerAvatar: json['blackPlayerAvatar'],
      result: json['result'] ?? 'draw',
      winnerId: json['winnerId'],
      endReason: json['endReason'] ?? 'unknown',
      moves: List<String>.from(json['moves'] ?? []),
      gameMode: json['gameMode'] ?? 'classical',
      durationSeconds: json['durationSeconds'] ?? 0,
      playedAt: json['playedAt'] != null
          ? DateTime.parse(json['playedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'whitePlayerId': whitePlayerId,
      'blackPlayerId': blackPlayerId,
      'whitePlayerName': whitePlayerName,
      'blackPlayerName': blackPlayerName,
      'whitePlayerAvatar': whitePlayerAvatar,
      'blackPlayerAvatar': blackPlayerAvatar,
      'result': result,
      'winnerId': winnerId,
      'endReason': endReason,
      'moves': moves,
      'gameMode': gameMode,
      'durationSeconds': durationSeconds,
      'playedAt': playedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameHistoryModel &&
          runtimeType == other.runtimeType &&
          gameId == other.gameId;

  @override
  int get hashCode => gameId.hashCode;
}
