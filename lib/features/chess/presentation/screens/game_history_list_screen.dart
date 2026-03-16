import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/game_record_model.dart';
import '../providers/game_replay_provider.dart';
import 'game_replay_screen.dart';

/// Game history list screen
class GameHistoryScreen extends ConsumerStatefulWidget {
  const GameHistoryScreen({super.key});

  @override
  ConsumerState<GameHistoryScreen> createState() => _GameHistoryScreenState();
}

class _GameHistoryScreenState extends ConsumerState<GameHistoryScreen> {
  late ScrollController _scrollController;
  String _searchQuery = '';
  String _filterResult = 'all'; // all, wins, losses, draws

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameHistoryAsync = ref.watch(gameHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Game History'), centerTitle: true),
      body: gameHistoryAsync.when(
        data: (games) {
          if (games.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No games yet',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Play some games to see your history',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          // Filter games
          var filteredGames = games.where((game) {
            final matchesFilter = _filterResult == 'all' ||
                (_filterResult == 'wins' && game.result == '1-0') ||
                (_filterResult == 'losses' && game.result == '0-1') ||
                (_filterResult == 'draws' && game.result == '1/2-1/2');

            final matchesSearch = _searchQuery.isEmpty ||
                game.whitePlayerName.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                game.blackPlayerName.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    );

            return matchesFilter && matchesSearch;
          }).toList();

          return Column(
            children: [
              // Search and filter
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search opponent...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            selected: _filterResult == 'all',
                            label: const Text('All'),
                            onSelected: (_) {
                              setState(() => _filterResult = 'all');
                            },
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            selected: _filterResult == 'wins',
                            label: const Text('Wins'),
                            onSelected: (_) {
                              setState(() => _filterResult = 'wins');
                            },
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            selected: _filterResult == 'losses',
                            label: const Text('Losses'),
                            onSelected: (_) {
                              setState(() => _filterResult = 'losses');
                            },
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            selected: _filterResult == 'draws',
                            label: const Text('Draws'),
                            onSelected: (_) {
                              setState(() => _filterResult = 'draws');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Game list
              Expanded(
                child: filteredGames.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            const Text('No games found'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: filteredGames.length,
                        itemBuilder: (context, index) {
                          return _GameHistoryTile(
                            game: filteredGames[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GameReplayScreen(
                                    gameRecord: filteredGames[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 48, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(gameHistoryProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual game history tile
class _GameHistoryTile extends StatelessWidget {
  final GameRecord game;
  final VoidCallback onTap;

  const _GameHistoryTile({required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    final resultColor = game.result == '1-0'
        ? Colors.green
        : game.result == '0-1'
            ? Colors.red
            : Colors.grey;
    final resultText = game.result == '1-0'
        ? 'White wins'
        : game.result == '0-1'
            ? 'Black wins'
            : 'Draw';

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // Players names and result
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.whitePlayerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'White',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: resultColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Text(
                        game.result,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: resultColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        resultText,
                        style: TextStyle(fontSize: 10, color: resultColor),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        game.blackPlayerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Black',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            // Game details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      game.timeControl,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      game.termination,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(game.playedAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
