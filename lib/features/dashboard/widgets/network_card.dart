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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📶 Network Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            InfoTile(
              title: "WiFi SSID",
              value: wifiName,
            ),

            InfoTile(
              title: "IP Address",
              value: ipAddress,
            ),

            InfoTile(
              title: "RSSI",
              value: wifiSignal,
            ),
          ],
        ),
      ),
    );
  }
}