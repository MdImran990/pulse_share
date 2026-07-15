import 'package:flutter/material.dart';

import 'info_tile.dart';

class DeviceCard extends StatelessWidget {
  final String model;
  final String androidVersion;
  final String deviceName;

  const DeviceCard({
    super.key,
    required this.model,
    required this.androidVersion,
    required this.deviceName,
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
              "📱 Device Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            InfoTile(
              title: "Model",
              value: model,
            ),

            InfoTile(
              title: "Android",
              value: androidVersion,
            ),

            InfoTile(
              title: "Device Name",
              value: deviceName,
            ),
          ],
        ),
      ),
    );
  }
}