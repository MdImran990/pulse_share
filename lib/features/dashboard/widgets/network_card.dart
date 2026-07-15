import 'package:flutter/material.dart';
import 'info_tile.dart';

class NetworkCard extends StatelessWidget {
  final String wifiName;
  final String ipAddress;
  final String wifiSignal;

  const NetworkCard({
    super.key,
    required this.wifiName,
    required this.ipAddress,
    required this.wifiSignal,
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
                    color: Colors.teal.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi,
                    color: Colors.teal,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Network Information",
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
                    title: "WiFi SSID",
                    value: wifiName,
                    icon: Icons.ssid_chart,
                  ),
                ),
                Expanded(
                  child: InfoTile(
                    title: "IP Address",
                    value: ipAddress,
                    icon: Icons.dns,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: "RSSI (Signal Strength)",
                    value: wifiSignal,
                    icon: Icons.signal_wifi_4_bar,
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