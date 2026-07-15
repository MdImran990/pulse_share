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
      elevation: 3,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone_android_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peer.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.settings_ethernet,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${peer.ip}:${peer.port}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontFamily: "monospace",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () async {
                try {
                  await shareController.sharePulse(
                    peer: peer,
                    pulseData: dashboardController.getPulseData(),
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Share",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.send_rounded, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}