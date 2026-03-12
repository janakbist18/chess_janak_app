import 'package:flutter/material.dart';

/// QR invite card widget
class QrInviteCard extends StatelessWidget {
  final String qrData;

  const QrInviteCard({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Scan QR Code'),
            const SizedBox(height: 12),
            Container(
              width: 200,
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.qr_code_2, size: 100)),
            ),
            const SizedBox(height: 12),
            Text(
              'Let opponent scan to join',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
