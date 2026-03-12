import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/premium_card.dart';
import '../providers/rooms_provider.dart';

class JoinRoomScreen extends ConsumerStatefulWidget {
  final String? inviteCode;

  const JoinRoomScreen({super.key, this.inviteCode});

  @override
  ConsumerState<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends ConsumerState<JoinRoomScreen> {
  late TextEditingController _inviteCodeController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _inviteCodeController =
        TextEditingController(text: widget.inviteCode ?? '');
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinRoom() async {
    final inviteCode = _inviteCodeController.text.trim().toUpperCase();

    if (inviteCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an invite code')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final roomInfo = await ref.read(inviteLookupProvider(inviteCode).future);

      if (mounted) {
        if (roomInfo.isNotEmpty && roomInfo['room_id'] != null) {
          // Join the room
          final joinResult = await ref.read(
            joinRoomProvider(inviteCode).future,
          );

          if (joinResult) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successfully joined room!')),
            );
            if (mounted) {
              Navigator.of(context).pop();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to join room')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid invite code')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Room')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Invite Code',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ask your opponent for the invite code they received when creating the room.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _inviteCodeController,
                    decoration: InputDecoration(
                      labelText: 'Invite Code',
                      hintText: 'e.g., ABC123',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    enabled: !_isLoading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _joinRoom,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.login),
              label: Text(_isLoading ? 'Joining...' : 'Join Room'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
