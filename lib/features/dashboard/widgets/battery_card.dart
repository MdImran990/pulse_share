import 'package:flutter/material.dart';

class BatteryCard extends StatelessWidget {
  final String level;
  final String temperature;
  final String health;

  const BatteryCard({
    super.key,
    required this.level,
    required this.temperature,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Battery Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text("Level : $level"),
            Text("Temperature : $temperature"),
            Text("Health : $health"),
          ],
        ),
      ),
    );
  }
}