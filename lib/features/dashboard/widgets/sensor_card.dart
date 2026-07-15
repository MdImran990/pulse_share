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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🚶 Sensor Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            InfoTile(
              title: "Steps",
              value: stepCount,
            ),

            InfoTile(
              title: "Activity",
              value: activity,
            ),
          ],
        ),
      ),
    );
  }
}