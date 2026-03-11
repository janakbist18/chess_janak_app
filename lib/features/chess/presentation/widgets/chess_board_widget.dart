import 'package:flutter/material.dart';

/// Chess board widget
class ChessBoardWidget extends StatelessWidget {
  final String fen;
  final Function(String from, String to) onMoveMade;

  const ChessBoardWidget({
    Key? key,
    required this.fen,
    required this.onMoveMade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: const Center(child: Text('Chess Board Widget')),
    );
  }
}
