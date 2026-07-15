import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/peer_model.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/share_controller.dart';

class PeerTile extends StatelessWidget {
  final PeerModel peer;

  const PeerTile({
    super.key,
    required this.peer,
  });

  @override
  Widget build(BuildContext context) {
    final ShareController shareController = Get.find<ShareController>();
    final DashboardController dashboardController =
    Get.find<DashboardController>();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 24,
          child: Icon(Icons.phone_android),
        ),
        title: Text(
          peer.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("IP : ${peer.ip}"),
            Text("Port : ${peer.port}"),
          ],
        ),
        trailing: ElevatedButton.icon(
          icon: const Icon(Icons.send),
          label: const Text("Share"),
          onPressed: () async {
            try {
              await shareController.sharePulse(
                peer: peer,
                pulseData: dashboardController.getPulseData(),
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Pulse shared to ${peer.name}",
                    ),
                  ),
                );
              }
            } catch (e) {
              Get.snackbar(
                "Share Failed",
                e.toString(),
              );
            }
          },
        ),
      ),
    );
  }
}