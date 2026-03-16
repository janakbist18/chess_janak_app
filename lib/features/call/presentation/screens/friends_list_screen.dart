import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Friends List Screen with social features
class FriendsListScreen extends ConsumerStatefulWidget {
  const FriendsListScreen({super.key});

  @override
  ConsumerState<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends ConsumerState<FriendsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👭 Friends'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Friends'),
            Tab(text: 'Requests'),
            Tab(text: 'Blocked'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search friends...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsList(),
                _buildFriendRequests(),
                _buildBlockedList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddFriendDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('Add Friend'),
      ),
    );
  }

  Widget _buildFriendsList() {
    final friends = [
      _FriendData(
        name: 'Alex Chen',
        username: '@alexchess',
        rating: 2150,
        status: 'online',
        lastActive: 'now',
        mutualFriends: 5,
      ),
      _FriendData(
        name: 'Sarah Johnson',
        username: '@sarahj',
        rating: 1950,
        status: 'offline',
        lastActive: '2 hours ago',
        mutualFriends: 3,
      ),
      _FriendData(
        name: 'Krishna Patel',
        username: '@krishnap',
        rating: 2050,
        status: 'online',
        lastActive: 'now',
        mutualFriends: 7,
      ),
      _FriendData(
        name: 'Emma Williams',
        username: '@emmaw',
        rating: 1850,
        status: 'offline',
        lastActive: '1 hour ago',
        mutualFriends: 2,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: friends.length,
      itemBuilder: (context, index) => _FriendCard(friend: friends[index]),
    );
  }

  Widget _buildFriendRequests() {
    final requests = [
      _FriendData(
        name: 'John Developer',
        username: '@johndev',
        rating: 1750,
        mutualFriends: 4,
      ),
      _FriendData(
        name: 'Lisa Singh',
        username: '@lisas',
        rating: 1900,
        mutualFriends: 3,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: requests.length,
      itemBuilder: (context, index) => _FriendRequestCard(
        friend: requests[index],
        onAccept: () {},
        onDecline: () {},
      ),
    );
  }

  Widget _buildBlockedList() {
    final blocked = [
      _FriendData(
        name: 'Spammer User',
        username: '@spammer123',
        rating: 1000,
        mutualFriends: 0,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: blocked.length,
      itemBuilder: (context, index) => _BlockedUserCard(
        friend: blocked[index],
        onUnblock: () {},
      ),
    );
  }

  void _showAddFriendDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Friend'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter username or email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _FriendData {
  final String name;
  final String username;
  final int rating;
  final String? status;
  final String? lastActive;
  final int mutualFriends;

  _FriendData({
    required this.name,
    required this.username,
    required this.rating,
    this.status,
    this.lastActive,
    required this.mutualFriends,
  });
}

class _FriendCard extends StatelessWidget {
  final _FriendData friend;

  const _FriendCard({required this.friend});

  @override
  Widget build(BuildContext context) {
    final isOnline = friend.status == 'online';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade200,
            child: Text(
              friend.name[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        friend.name,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            friend.username,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.star, size: 12, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${friend.rating}  •  ${friend.mutualFriends} mutual',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(child: Text('Challenge')),
          const PopupMenuItem(child: Text('Message')),
          const PopupMenuItem(child: Text('Block')),
        ],
      ),
    );
  }
}

class _FriendRequestCard extends StatelessWidget {
  final _FriendData friend;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _FriendRequestCard({
    required this.friend,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade200,
              child: Text(friend.name[0]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${friend.mutualFriends} mutual friends',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            Row(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: onDecline,
                  child: const Text('Decline'),
                ),
                ElevatedButton(
                  onPressed: onAccept,
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockedUserCard extends StatelessWidget {
  final _FriendData friend;
  final VoidCallback onUnblock;

  const _BlockedUserCard({
    required this.friend,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey.shade300,
          child: const Icon(Icons.block, color: Colors.red),
        ),
        title: Text(friend.name),
        subtitle: Text(friend.username),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          onPressed: onUnblock,
          child: const Text('Unblock'),
        ),
      ),
    );
  }
}
