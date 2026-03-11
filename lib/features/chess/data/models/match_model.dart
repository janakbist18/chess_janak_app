/// Match model
class MatchModel {
  final String matchId;
  final String whitePlayerName;
  final String blackPlayerName;
  final String? whitePlayerImage;
  final String? blackPlayerImage;
  final int whitePlayerRating;
  final int blackPlayerRating;
  final String result;
  final String resultReason;
  final int moveCount;
  final DateTime playedAt;

  MatchModel({
    required this.matchId,
    required this.whitePlayerName,
    required this.blackPlayerName,
    this.whitePlayerImage,
    this.blackPlayerImage,
    this.whitePlayerRating = 1200,
    this.blackPlayerRating = 1200,
    required this.result,
    required this.resultReason,
    this.moveCount = 0,
    required this.playedAt,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchId: json['matchId'] as String,
      whitePlayerName: json['whitePlayerName'] as String,
      blackPlayerName: json['blackPlayerName'] as String,
      whitePlayerImage: json['whitePlayerImage'] as String?,
      blackPlayerImage: json['blackPlayerImage'] as String?,
      whitePlayerRating: json['whitePlayerRating'] as int? ?? 1200,
      blackPlayerRating: json['blackPlayerRating'] as int? ?? 1200,
      result: json['result'] as String,
      resultReason: json['resultReason'] as String,
      moveCount: json['moveCount'] as int? ?? 0,
      playedAt: DateTime.parse(json['playedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'matchId': matchId,
    'whitePlayerName': whitePlayerName,
    'blackPlayerName': blackPlayerName,
    'whitePlayerImage': whitePlayerImage,
    'blackPlayerImage': blackPlayerImage,
    'whitePlayerRating': whitePlayerRating,
    'blackPlayerRating': blackPlayerRating,
    'result': result,
    'resultReason': resultReason,
    'moveCount': moveCount,
    'playedAt': playedAt.toIso8601String(),
  };
}
