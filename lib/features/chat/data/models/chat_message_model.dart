/// Chat message model
class ChatMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String message;
  final DateTime sentAt;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.message,
    required this.sentAt,
    this.isRead = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderImage: json['senderImage'] as String?,
      message: json['message'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'senderName': senderName,
    'senderImage': senderImage,
    'message': message,
    'sentAt': sentAt.toIso8601String(),
    'isRead': isRead,
  };
}
