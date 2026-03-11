/// Join room request model
class JoinRoomRequestModel {
  final String roomId;
  final String? inviteCode;

  JoinRoomRequestModel({required this.roomId, this.inviteCode});

  Map<String, dynamic> toJson() => {'roomId': roomId, 'inviteCode': inviteCode};
}
