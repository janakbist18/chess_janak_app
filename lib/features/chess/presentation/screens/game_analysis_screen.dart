import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Game Analysis and Replay Screen
class GameAnalysisScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GameAnalysisScreen({
    super.key,
    required this.gameId,
  });

  @override
  ConsumerState<GameAnalysisScreen> createState() => _GameAnalysisScreenState();
}

class _GameAnalysisScreenState extends ConsumerState<GameAnalysisScreen> {
  int _currentMoveIndex = 0;
  bool _showAnalysis = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Analysis'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showAnalysis ? Icons.analytics : Icons.analytics_outlined,
            ),
            tooltip: 'Toggle Analysis',
            onPressed: () => setState(() => _showAnalysis = !_showAnalysis),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download PGN',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Game downloaded as PGN')),
              );
            },
          ),
        ],
      ),
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 12,
        children: [
          _buildGameInfo(),
          _buildBoardPreview(),
          _buildMoveControls(),
          _buildMovesList(),
          if (_showAnalysis) _buildAnalysisPanel(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      spacing: 16,
      children: [
        // Left side - Board and moves
        Expanded(
          flex: 2,
          child: Column(
            spacing: 12,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  spacing: 12,
                  children: [
                    _buildGameInfo(),
                    _buildBoardPreview(),
                    _buildMoveControls(),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildMovesList(),
                ),
              ),
            ],
          ),
        ),
        // Right side - Analysis
        if (_showAnalysis)
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Analysis',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Expanded(
                  child: _buildAnalysisPanel(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildGameInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'White: AlexChess (2150)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Black: YourName (1850)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Draw',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _GameDetailItem('Format', 'Blitz (5+3)'),
                _GameDetailItem('Date', 'Mar 12, 2026'),
                _GameDetailItem('Moves', '42'),
                _GameDetailItem('Duration', '8m 23s'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoardPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Move ${_currentMoveIndex + 1}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '♙ ♖ ♗ ♘ ♕ ♔',
                    style: TextStyle(fontSize: 48),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoveControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: () => setState(() => _currentMoveIndex = 0),
              tooltip: 'Start',
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(
                () => _currentMoveIndex = (_currentMoveIndex - 1).clamp(0, 41),
              ),
              tooltip: 'Previous',
            ),
            Expanded(
              child: Slider(
                value: _currentMoveIndex.toDouble(),
                min: 0,
                max: 41,
                divisions: 41,
                label: 'Move $_currentMoveIndex',
                onChanged: (value) =>
                    setState(() => _currentMoveIndex = value.toInt()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => setState(
                () => _currentMoveIndex = (_currentMoveIndex + 1).clamp(0, 41),
              ),
              tooltip: 'Next',
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () => setState(() => _currentMoveIndex = 41),
              tooltip: 'End',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovesList() {
    final moves = [
      '1. e4 c5',
      '2. Nf3 d6',
      '3. d4 cxd4',
      '4. Nxd4 Nf6',
      '5. Nc3 a6',
      '6. Bg5 e6',
      '7. f4 Be7',
      '8. Qf3 Nbd7',
      '9. O-O-O b5',
      '10. Bxf6 Nxf6',
      '11. Kb1 Bb7',
      '12. a3 Be4',
      '13. Qg3 Qc7',
      '14. Nd5 Bxd5',
      '15. exd5 Rc8',
      '16. Kb2 b4',
      '17. axb4 Nxb4',
      '18. Bxb4 Rxc3',
      '19. bxc3 Qxc3',
      '20. Ka2 Qxa3+',
      '21. Kb1 Draw',
    ];

    return Card(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: moves.length,
        itemBuilder: (context, index) {
          final isSelected = index == _currentMoveIndex;
          return ListTile(
            dense: true,
            selected: isSelected,
            selectedTileColor: Colors.blue[50],
            title: Text(
              moves[index],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue : null,
                  ),
            ),
            onTap: () => setState(() => _currentMoveIndex = index),
          );
        },
      ),
    );
  }

  Widget _buildAnalysisPanel() {
    return Card(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnalysisSection(
              'Move Quality',
              [
                _QualityIndicator('Excellent', 95, Colors.green),
                _QualityIndicator('Good', 78, Colors.blue),
                _QualityIndicator('Okay', 65, Colors.orange),
                _QualityIndicator('Blunder', 20, Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            _buildAnalysisSection(
              'Top Moves',
              [
                _MoveOption('1. e4', 'Best move', Colors.green, 98),
                _MoveOption('1. d4', 'Good alternative', Colors.blue, 85),
                _MoveOption('1. c4', 'Playable', Colors.grey, 72),
              ],
            ),
            const SizedBox(height: 16),
            _buildAnalysisSection(
              'Evaluation',
              [
                _EvaluationChart(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class _GameDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _GameDetailItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _QualityIndicator extends StatelessWidget {
  final String label;
  final int percentage;
  final Color color;

  const _QualityIndicator(this.label, this.percentage, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '$percentage%',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoveOption extends StatelessWidget {
  final String move;
  final String description;
  final Color color;
  final int score;

  const _MoveOption(this.move, this.description, this.color, this.score);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(6),
          color: color.withOpacity(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  move,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$score%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvaluationChart extends StatelessWidget {
  const _EvaluationChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Evaluation Graph',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '📊',
              style: const TextStyle(fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }
}
