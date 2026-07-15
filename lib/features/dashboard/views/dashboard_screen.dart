import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/battery_card.dart';
import '../widgets/device_card.dart';
import '../widgets/network_card.dart';
import '../widgets/sensor_card.dart';
import '../widgets/sim_card.dart';
import '../widgets/share_button.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pulse Share Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Received Pulses",
            onPressed: () => Get.toNamed(AppRoutes.received),
            icon: const Icon(Icons.history, size: 28),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadDashboardData(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DeviceCard(
                model: controller.deviceModel.value,
                androidVersion: controller.androidVersion.value,
                deviceName: controller.deviceName.value,
              ),

              const SizedBox(height: 16),

              BatteryCard(
                level: controller.batteryLevel.value,
                temperature: controller.batteryTemp.value,
                health: controller.batteryHealth.value,
              ),

              const SizedBox(height: 16),

              NetworkCard(
                wifiName: controller.wifiName.value,
                ipAddress: controller.ipAddress.value,
                wifiSignal: controller.wifiSignal.value,
              ),

              const SizedBox(height: 16),

              SimCard(
                carrier: controller.simCarrier.value,
                state: controller.simState.value,
                signal: controller.simSignal.value,
              ),

              const SizedBox(height: 16),

              SensorCard(
                stepCount: controller.stepCount.value,
                activity: controller.activity.value,
              ),

              const SizedBox(height: 24),

              const ShareButton(),
            ],
          ),
        );
      }),
    );
  }
}
