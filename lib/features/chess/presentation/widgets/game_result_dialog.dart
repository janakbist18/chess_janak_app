import 'package:flutter/material.dart';

/// Game result dialog widget
class GameResultDialog extends StatelessWidget {
  final String result;
  final String resultReason;
  final VoidCallback onClose;
  final VoidCallback? onPlayAgain;

  const GameResultDialog({
    Key? key,
    required this.result,
    required this.resultReason,
    required this.onClose,
    this.onPlayAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Game Over'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(result, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(resultReason),
        ],
      ),
      actions: [
        TextButton(onPressed: onClose, child: const Text('Close')),
        if (onPlayAgain != null)
          ElevatedButton(
            onPressed: onPlayAgain,
            child: const Text('Play Again'),
          ),
      ],
    );
  }
}
