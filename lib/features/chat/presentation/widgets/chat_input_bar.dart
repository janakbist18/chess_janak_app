import 'package:flutter/material.dart';

/// Chat input bar widget
class ChatInputBar extends StatefulWidget {
  final Function(String) onSendMessage;

  const ChatInputBar({super.key, required this.onSendMessage});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                widget.onSendMessage(_controller.text);
                _controller.clear();
              }
            },
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
