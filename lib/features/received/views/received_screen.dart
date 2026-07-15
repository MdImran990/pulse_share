import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/received_controller.dart';
import '../widgets/snapshot_card.dart';

class ReceivedScreen extends GetView<ReceivedController> {
  const ReceivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Received Pulse"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.clearAll,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.receivedList.isEmpty) {
          return const Center(
            child: Text(
              "No Pulse Received Yet",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.receivedList.length,
          itemBuilder: (context, index) {
            return SnapshotCard(
              data: controller.receivedList[index],
            );
          },
        );
      }),
    );
  }
}