import 'package:flutter/material.dart';

/// Call overlay widget
class CallOverlay extends StatelessWidget {
  final String opponentName;
  final String callStatus;
  final VoidCallback onDecline;
  final VoidCallback onAccept;

  const CallOverlay({
    super.key,
    required this.opponentName,
    required this.callStatus,
    required this.onDecline,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(opponentName, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(callStatus, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: onDecline,
                child: const Icon(Icons.call_end),
              ),
              FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: onAccept,
                child: const Icon(Icons.call),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
