import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/empty_widget.dart';
import '../controllers/share_controller.dart';
import '../widgets/peer_tile.dart';

class ShareScreen extends GetView<ShareController> {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Devices"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.peers.isEmpty) {
          return EmptyWidget(
            icon: Icons.wifi_find_rounded,
            title: "Searching for Devices...",
            subtitle: "Make sure other devices are on the same Wi-Fi and have Pulse Share open.",
            onRetry: () => controller.discoverPeers(),
            retryLabel: "Scan Again",
          );
        }

        return RefreshIndicator(
          onRefresh: controller.discoverPeers,
          child: ListView.builder(
            itemCount: controller.peers.length,
            itemBuilder: (context, index) {
              return PeerTile(
                peer: controller.peers[index],
              );
            },
          ),
        );
      }),
    );
  }
}