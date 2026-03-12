import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/premium_card.dart';
import '../providers/rooms_provider.dart';

class WaitingRoomScreen extends ConsumerStatefulWidget {
  final String roomId;

  const WaitingRoomScreen({super.key, required this.roomId});

  @override
  ConsumerState<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends ConsumerState<WaitingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final roomDetailsAsync = ref.watch(roomDetailsProvider(widget.roomId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting Room'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: roomDetailsAsync.when(
        data: (roomData) {
          if (roomData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Loading room...'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // ignore: unused_result
                      ref.refresh(roomDetailsProvider(widget.roomId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final isWaiting = ref.watch(isRoomWaitingProvider(roomData));
          final opponent = ref.watch(opponentProvider(roomData));
          final playerColor = ref.watch(playerColorProvider(roomData));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PremiumCard(
                  child: Column(
                    children: [
                      if (isWaiting)
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Waiting for opponent...',
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Your opponent will join soon',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      else
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            const Icon(
                              Icons.check_circle,
                              size: 48,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Opponent Found!',
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Room Information',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoTile('Room ID', widget.roomId),
                      _buildInfoTile(
                        'Your Color',
                        playerColor?.toUpperCase() ?? 'Unknown',
                      ),
                      _buildInfoTile(
                        'Game Mode',
                        roomData['game_mode'] ?? 'Unknown',
                      ),
                      if (roomData['time_limit'] != null)
                        _buildInfoTile(
                          'Time Limit',
                          '${roomData['time_limit']} minutes',
                        ),
                    ],
                  ),
                ),
                if (opponent != null && !isWaiting) ...[
                  const SizedBox(height: 16),
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Opponent',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoTile(
                          'Username',
                          opponent['username'] ?? 'Anonymous',
                        ),
                        if (opponent['rating'] != null)
                          _buildInfoTile(
                            'Rating',
                            '${opponent['rating']}',
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (!isWaiting) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to game screen
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Game'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Leave Room'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // ignore: unused_result
                  ref.refresh(roomDetailsProvider(widget.roomId));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
