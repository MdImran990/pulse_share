import 'package:flutter/material.dart';
import 'info_tile.dart';

class SensorCard extends StatelessWidget {
  final String stepCount;
  final String activity;

  const SensorCard({
    super.key,
    required this.stepCount,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_run,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Sensor Information",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: "Steps (Since Boot)",
                    value: stepCount,
                    icon: Icons.directions_walk,
                  ),
                ),
                Expanded(
                  child: InfoTile(
                    title: "Current Activity",
                    value: activity,
                    icon: Icons.accessibility_new,
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