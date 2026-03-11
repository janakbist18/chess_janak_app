/// Create room response model
class CreateRoomResponseModel {
  final String roomId;
  final String inviteCode;
  final DateTime createdAt;

  CreateRoomResponseModel({
    required this.roomId,
    required this.inviteCode,
    required this.createdAt,
  });

  factory CreateRoomResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateRoomResponseModel(
      roomId: json['roomId'],
      inviteCode: json['inviteCode'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'inviteCode': inviteCode,
    'createdAt': createdAt.toIso8601String(),
  };
}
