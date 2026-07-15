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
                    color: Colors.blue.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phone_android,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Device Information",
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
                    title: "Model",
                    value: model,
                    icon: Icons.label_important,
                  ),
                ),
                Expanded(
                  child: InfoTile(
                    title: "Android Version",
                    value: androidVersion,
                    icon: Icons.android,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: "Device Name",
                    value: deviceName,
                    icon: Icons.devices,
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