import 'package:flutter/material.dart';

class SnapshotCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const SnapshotCard({
    super.key,
    required this.data,
  });

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String deviceName = data["deviceName"] ?? "Device";
    final String deviceModel = data["deviceModel"] ?? "--";
    final String receivedAt = data["receivedAt"] != null
        ? DateTime.parse(data["receivedAt"]).toLocal().toString().substring(0, 19)
        : "--";

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.phonelink_setup,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          "$deviceName ($deviceModel)",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          "Received: $receivedAt",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Device Section
          _buildSectionHeader(context, "Device & OS", Icons.android),
          const SizedBox(height: 6),
          _buildInfoRow("Android Version", data["androidVersion"] ?? "--"),
          const Divider(height: 16),

          // Battery Section
          _buildSectionHeader(context, "Battery Status", Icons.battery_charging_full),
          const SizedBox(height: 6),
          _buildInfoRow("Level", data["batteryLevel"] ?? "--"),
          _buildInfoRow("Temperature", data["batteryTemperature"] ?? "--"),
          _buildInfoRow("Health", data["batteryHealth"] ?? "--"),
          const Divider(height: 16),

          // Wi-Fi Section
          _buildSectionHeader(context, "Wi-Fi Details", Icons.wifi),
          const SizedBox(height: 6),
          _buildInfoRow("SSID", data["wifiName"] ?? "--"),
          _buildInfoRow("IP Address", data["ipAddress"] ?? "--"),
          _buildInfoRow("Signal Strength", data["wifiSignal"] ?? "--"),
          const Divider(height: 16),

          // SIM Section
          _buildSectionHeader(context, "SIM Connection", Icons.sim_card),
          const SizedBox(height: 6),
          _buildInfoRow("Carrier", data["simCarrier"] ?? "--"),
          _buildInfoRow("SIM State", data["simState"] ?? "--"),
          _buildInfoRow("Signal (dBm)", data["simSignal"] ?? "--"),
          const Divider(height: 16),

          // Sensors Section
          _buildSectionHeader(context, "Activity & Health", Icons.directions_run),
          const SizedBox(height: 6),
          _buildInfoRow("Steps (Since Boot)", data["stepCount"] ?? "--"),
          _buildInfoRow("Current Motion", data["activity"] ?? "--"),
        ],
      ),
    );
  }
}
