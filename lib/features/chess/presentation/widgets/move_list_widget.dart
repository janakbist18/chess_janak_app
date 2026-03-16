import 'package:flutter/material.dart';

/// Widget to display move history
class MoveListWidget extends StatelessWidget {
  final List<String> moves;
  final int? selectedMoveIndex;
  final Function(int)? onMoveTapped;

  const MoveListWidget({
    super.key,
    required this.moves,
    this.selectedMoveIndex,
    this.onMoveTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (moves.isEmpty) {
      return Center(
        child: Text(
          'No moves yet',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      itemCount: (moves.length / 2).ceil(),
      itemBuilder: (context, index) {
        final whiteMove = moves[index * 2];
        final blackMove =
            index * 2 + 1 < moves.length ? moves[index * 2 + 1] : null;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  '${index + 1}.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: _buildMoveChip(
                  context,
                  whiteMove,
                  index * 2,
                  selectedMoveIndex == index * 2,
                ),
              ),
              const SizedBox(width: 8),
              if (blackMove != null)
                Expanded(
                  child: _buildMoveChip(
                    context,
                    blackMove,
                    index * 2 + 1,
                    selectedMoveIndex == index * 2 + 1,
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoveChip(
    BuildContext context,
    String move,
    int moveIndex,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: onMoveTapped != null ? () => onMoveTapped!(moveIndex) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          move,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
