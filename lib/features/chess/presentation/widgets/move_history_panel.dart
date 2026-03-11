import 'package:flutter/material.dart';

/// Move history panel widget
class MoveHistoryPanel extends StatelessWidget {
  final List<String> moves;

  const MoveHistoryPanel({Key? key, required this.moves}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Move History', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: moves.length,
                itemBuilder: (context, index) {
                  return Text('${index + 1}. ${moves[index]}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
