import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget to display game timer
class GameTimerWidget extends ConsumerWidget {
  final bool isWhiteTimer;
  final bool isActive;

  const GameTimerWidget({
    Key? key,
    required this.isWhiteTimer,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch timer state from provider
    final timerState = null;

    final timeRemaining = isWhiteTimer
        ? timerState.whiteTimeRemaining
        : timerState.blackTimeRemaining;
    final formattedTime = timerState.formatTime(timeRemaining);

    final isLowTime = timeRemaining < 60;
    final isCriticalTime = timeRemaining < 10;

    Color getTextColor() {
      if (isCriticalTime) return Colors.red;
      if (isLowTime) return Colors.orange;
      return Colors.black;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.shade50 : Colors.grey.shade100,
        border: Border.all(
          color: isActive ? Colors.blue : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isWhiteTimer ? 'White' : 'Black',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedTime,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: getTextColor(),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
          ),
        ],
      ),
    );
  }
}
