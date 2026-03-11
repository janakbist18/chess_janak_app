import 'package:flutter/material.dart';

/// Call controls bar widget
class CallControlsBar extends StatelessWidget {
  final VoidCallback onMutePressed;
  final VoidCallback onVideoPressed;
  final VoidCallback onEndCallPressed;
  final bool isMuted;
  final bool isVideoEnabled;

  const CallControlsBar({
    Key? key,
    required this.onMutePressed,
    required this.onVideoPressed,
    required this.onEndCallPressed,
    this.isMuted = false,
    this.isVideoEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            backgroundColor: isMuted
                ? Colors.red
                : Theme.of(context).primaryColor,
            onPressed: onMutePressed,
            child: Icon(isMuted ? Icons.mic_off : Icons.mic),
          ),
          FloatingActionButton(
            backgroundColor: isVideoEnabled
                ? Theme.of(context).primaryColor
                : Colors.red,
            onPressed: onVideoPressed,
            child: Icon(isVideoEnabled ? Icons.videocam : Icons.videocam_off),
          ),
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: onEndCallPressed,
            child: const Icon(Icons.call_end),
          ),
        ],
      ),
    );
  }
}
