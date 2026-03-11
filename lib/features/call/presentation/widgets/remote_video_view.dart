import 'package:flutter/material.dart';

/// Remote video view widget
class RemoteVideoView extends StatelessWidget {
  const RemoteVideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(child: Text('Remote Video')),
    );
  }
}
