import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          return const Center(
            child: Text("No Nearby Device Found"),
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