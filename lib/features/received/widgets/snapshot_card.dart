import 'package:flutter/material.dart';

class SnapshotCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const SnapshotCard({
    super.key,
    required this.data,
  });

  Widget item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            item("Battery", data["batteryLevel"] ?? "--"),
            item("Temperature", data["batteryTemperature"] ?? "--"),
            item("Health", data["batteryHealth"] ?? "--"),
            item("Model", data["deviceModel"] ?? "--"),
            item("Android", data["androidVersion"] ?? "--"),
            item("WiFi", data["wifiName"] ?? "--"),
            item("IP", data["ipAddress"] ?? "--"),
            item("Steps", data["stepCount"] ?? "--"),
            item("Activity", data["activity"] ?? "--"),
          ],
        ),
      ),
    );
  }
}