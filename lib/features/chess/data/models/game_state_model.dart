/// Game state model
class GameStateModel {
  final String gameId;
  final String whitePlayerId;
  final String blackPlayerId;
  final String whitePlayerName;
  final String blackPlayerName;
  final String? whitePlayerAvatar;
  final String? blackPlayerAvatar;
  final String fen;
  final List<String> moves;
  final String status;
  final String? winnerId;
  final String gameMode;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int? whiteTimeRemaining;
  final int? blackTimeRemaining;

  GameStateModel({
    required this.gameId,
    required this.whitePlayerId,
    required this.blackPlayerId,
    required this.whitePlayerName,
    required this.blackPlayerName,
    this.whitePlayerAvatar,
    this.blackPlayerAvatar,
    this.fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
    this.moves = const [],
    this.status = 'ongoing',
    this.winnerId,
    this.gameMode = 'classical',
    required this.createdAt,
    this.updatedAt,
    this.whiteTimeRemaining,
    this.blackTimeRemaining,
  });

  GameStateModel copyWith({
    String? gameId,
    String? whitePlayerId,
    String? blackPlayerId,
    String? whitePlayerName,
    String? blackPlayerName,
    String? whitePlayerAvatar,
    String? blackPlayerAvatar,
    String? fen,
    List<String>? moves,
    String? status,
    String? winnerId,
    String? gameMode,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? whiteTimeRemaining,
    int? blackTimeRemaining,
  }) {
    return GameStateModel(
      gameId: gameId ?? this.gameId,
      whitePlayerId: whitePlayerId ?? this.whitePlayerId,
      blackPlayerId: blackPlayerId ?? this.blackPlayerId,
      whitePlayerName: whitePlayerName ?? this.whitePlayerName,
      blackPlayerName: blackPlayerName ?? this.blackPlayerName,
      whitePlayerAvatar: whitePlayerAvatar ?? this.whitePlayerAvatar,
      blackPlayerAvatar: blackPlayerAvatar ?? this.blackPlayerAvatar,
      fen: fen ?? this.fen,
      moves: moves ?? this.moves,
      status: status ?? this.status,
      winnerId: winnerId ?? this.winnerId,
      gameMode: gameMode ?? this.gameMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      whiteTimeRemaining: whiteTimeRemaining ?? this.whiteTimeRemaining,
      blackTimeRemaining: blackTimeRemaining ?? this.blackTimeRemaining,
    );
  }

  factory GameStateModel.fromJson(Map<String, dynamic> json) {
    return GameStateModel(
      gameId: json['gameId'] ?? '',
      whitePlayerId: json['whitePlayerId'] ?? '',
      blackPlayerId: json['blackPlayerId'] ?? '',
      whitePlayerName: json['whitePlayerName'] ?? 'White',
      blackPlayerName: json['blackPlayerName'] ?? 'Black',
      whitePlayerAvatar: json['whitePlayerAvatar'],
      blackPlayerAvatar: json['blackPlayerAvatar'],
      fen: json['fen'] ??
          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      moves: List<String>.from(json['moves'] ?? []),
      status: json['status'] ?? 'ongoing',
      winnerId: json['winnerId'],
      gameMode: json['gameMode'] ?? 'classical',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      whiteTimeRemaining: json['whiteTimeRemaining'],
      blackTimeRemaining: json['blackTimeRemaining'],
    );
  }

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'whitePlayerId': whitePlayerId,
        'blackPlayerId': blackPlayerId,
        'whitePlayerName': whitePlayerName,
        'blackPlayerName': blackPlayerName,
        'whitePlayerAvatar': whitePlayerAvatar,
        'blackPlayerAvatar': blackPlayerAvatar,
        'fen': fen,
        'moves': moves,
        'status': status,
        'winnerId': winnerId,
        'gameMode': gameMode,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'whiteTimeRemaining': whiteTimeRemaining,
        'blackTimeRemaining': blackTimeRemaining,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStateModel &&
          runtimeType == other.runtimeType &&
          gameId == other.gameId &&
          fen == other.fen;

  @override
  int get hashCode => gameId.hashCode ^ fen.hashCode;
}
