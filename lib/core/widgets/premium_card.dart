import 'package:flutter/material.dart';

/// Reusable premium card widget
class PremiumCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> features;
  final String? price;
  final VoidCallback? onUpgrade;
  final Color? accentColor;

  const PremiumCard({
    Key? key,
    required this.title,
    required this.description,
    required this.features,
    this.price,
    this.onUpgrade,
    this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(description),
                    ],
                  ),
                ),
                if (price != null)
                  Text(
                    price!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: accentColor ?? Colors.orange,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.check, color: accentColor ?? Colors.green),
                    const SizedBox(width: 8),
                    Text(feature),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (onUpgrade != null)
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: onUpgrade,
                  child: const Text('Upgrade Now'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
