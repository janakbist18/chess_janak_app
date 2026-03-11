import 'package:flutter/material.dart';

/// Message bubble widget
class MessageBubble extends StatelessWidget {
  final String message;
  final String senderName;
  final bool isSentByCurrentUser;
  final String? senderImage;
  final DateTime sentAt;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.senderName,
    required this.isSentByCurrentUser,
    this.senderImage,
    required this.sentAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByCurrentUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSentByCurrentUser
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              senderName,
              style: TextStyle(
                fontSize: 10,
                color: isSentByCurrentUser ? Colors.white : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                color: isSentByCurrentUser ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
