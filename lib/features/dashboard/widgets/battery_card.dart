import 'package:flutter/material.dart';
import 'info_tile.dart';

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
                  decoration: const BoxDecoration(
                    color: Color(0x1aff0000), // red with 10% opacity / alpha 26
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.battery_charging_full,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Battery Information",
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
                    title: "Battery Level",
                    value: level,
                    icon: Icons.bolt,
                  ),
                ),
                Expanded(
                  child: InfoTile(
                    title: "Temperature",
                    value: temperature,
                    icon: Icons.thermostat,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: "Health Status",
                    value: health,
                    icon: Icons.health_and_safety,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}