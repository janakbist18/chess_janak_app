import 'package:flutter/material.dart';

/// Captured pieces widget
class CapturedPiecesWidget extends StatelessWidget {
  final List<String> whitePieces;
  final List<String> blackPieces;

  const CapturedPiecesWidget({
    Key? key,
    required this.whitePieces,
    required this.blackPieces,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text('White Captured'),
            Wrap(children: whitePieces.map((p) => Text(p)).toList()),
            const SizedBox(height: 12),
            Text('Black Captured'),
            Wrap(children: blackPieces.map((p) => Text(p)).toList()),
          ],
        ),
      ),
    );
  }
}
