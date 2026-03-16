import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tournament Management Screen
class TournamentScreen extends ConsumerStatefulWidget {
  const TournamentScreen({super.key});

  @override
  ConsumerState<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends ConsumerState<TournamentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Tournaments'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTournaments(),
          _buildUpcomingTournaments(),
          _buildPastTournaments(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateTournamentDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Tournament'),
      ),
    );
  }

  Widget _buildActiveTournaments() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _TournamentCard(
          title: 'Blitz Championship 2026',
          status: 'LIVE',
          participants: 24,
          rounds: 5,
          currentRound: 3,
          prize: '\$500',
        ),
        _TournamentCard(
          title: 'Rapid Tournament',
          status: 'LIVE',
          participants: 32,
          rounds: 6,
          currentRound: 2,
          prize: '\$1000',
        ),
      ],
    );
  }

  Widget _buildUpcomingTournaments() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _TournamentCard(
          title: 'Classical Championship',
          status: 'UPCOMING',
          participants: 16,
          rounds: 7,
          currentRound: 0,
          prize: '\$2000',
          startDate: 'Mar 20, 2026',
        ),
        _TournamentCard(
          title: 'Blitz World Cup',
          status: 'UPCOMING',
          participants: 64,
          rounds: 8,
          currentRound: 0,
          prize: '\$5000',
          startDate: 'Mar 28, 2026',
        ),
      ],
    );
  }

  Widget _buildPastTournaments() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _TournamentCard(
          title: 'Winter Blitz 2026',
          status: 'FINISHED',
          participants: 48,
          rounds: 5,
          currentRound: 5,
          prize: '\$750',
          placement: 3,
        ),
        _TournamentCard(
          title: 'February Rapid',
          status: 'FINISHED',
          participants: 20,
          rounds: 4,
          currentRound: 4,
          prize: '\$300',
          placement: 1,
        ),
      ],
    );
  }

  void _showCreateTournamentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Tournament'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tournament Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tournament Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'blitz', child: Text('Blitz')),
                  DropdownMenuItem(value: 'rapid', child: Text('Rapid')),
                  DropdownMenuItem(
                      value: 'classical', child: Text('Classical')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Max Participants',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 8, child: Text('8')),
                  DropdownMenuItem(value: 16, child: Text('16')),
                  DropdownMenuItem(value: 32, child: Text('32')),
                  DropdownMenuItem(value: 64, child: Text('64')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _TournamentCard extends StatelessWidget {
  final String title;
  final String status;
  final int participants;
  final int rounds;
  final int currentRound;
  final String prize;
  final String? startDate;
  final int? placement;

  const _TournamentCard({
    required this.title,
    required this.status,
    required this.participants,
    required this.rounds,
    required this.currentRound,
    required this.prize,
    this.startDate,
    this.placement,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'LIVE';
    final isUpcoming = status == 'UPCOMING';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.green
                                  : isUpcoming
                                      ? Colors.blue
                                      : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (placement != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade600,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#$placement',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (startDate != null)
                  Chip(
                    label: Text(startDate!),
                    backgroundColor: Colors.blue[50],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatColumn('Participants', '$participants'),
                _StatColumn('Prize Pool', prize),
                _StatColumn(
                  'Progress',
                  isActive ? '$currentRound/$rounds' : 'Finished',
                ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: currentRound / rounds,
                  minHeight: 6,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(Colors.blue.shade600),
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isUpcoming || !isActive)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Details'),
                    ),
                  ),
                if (isActive) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('View Bracket'),
                    ),
                  ),
                ] else
                  const SizedBox(),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(isUpcoming ? 'Join' : 'View Results'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn(this.label, this.value);

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
