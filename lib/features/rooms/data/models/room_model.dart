/// Room model
class RoomModel {
  final String id;
  final String name;
  final String? description;
  final String creatorId;
  final List<String> playerIds;
  final int maxPlayers;
  final String status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;

  RoomModel({
    required this.id,
    required this.name,
    this.description,
    required this.creatorId,
    required this.playerIds,
    this.maxPlayers = 2,
    this.status = 'waiting',
    required this.createdAt,
    this.startedAt,
    this.endedAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      creatorId: json['creatorId'],
      playerIds: List<String>.from(json['playerIds'] ?? []),
      maxPlayers: json['maxPlayers'] ?? 2,
      status: json['status'] ?? 'waiting',
      createdAt: DateTime.parse(json['createdAt']),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
      endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'creatorId': creatorId,
    'playerIds': playerIds,
    'maxPlayers': maxPlayers,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'startedAt': startedAt?.toIso8601String(),
    'endedAt': endedAt?.toIso8601String(),
  };
}
