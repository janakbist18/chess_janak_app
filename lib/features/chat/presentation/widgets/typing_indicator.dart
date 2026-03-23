import 'package:flutter/material.dart';

/// Typing indicator widget
class TypingIndicator extends StatelessWidget {
  final String? typingUserName;
  final bool isVisible;

  const TypingIndicator({super.key, this.typingUserName, this.isVisible = true});

  @override
  Widget build(BuildContext context) {
    if (!isVisible || typingUserName == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            '$typingUserName is typing',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 4),
          MessageDot(delay: 0),
          MessageDot(delay: 150),
          MessageDot(delay: 300),
        ],
      ),
    );
  }
}

class MessageDot extends StatefulWidget {
  final int delay;

  const MessageDot({super.key, required this.delay});

  @override
  State<MessageDot> createState() => _MessageDotState();
}

class _MessageDotState extends State<MessageDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.5,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: CircleAvatar(radius: 2),
      ),
    );
  }
}
