import 'package:flutter/material.dart';

/// Game room screen
class GameRoomScreen extends StatelessWidget {
  const GameRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Room')),
      body: const Center(child: Text('Game Room Screen')),
    );
  }
}
