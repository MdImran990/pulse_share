import 'package:get/get.dart';

import '../../core/services/battery_service.dart';
import '../../core/services/device_service.dart';
import '../../data/repository/dashboard_repository.dart';
import '../../data/repository/received_repository.dart';
import '../../features/received/controllers/received_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<BatteryService>(() => BatteryService());
    Get.lazyPut<DeviceService>(() => DeviceService());

    // Repositories
    Get.lazyPut<DashboardRepository>(() => DashboardRepository());
    Get.lazyPut<ReceivedRepository>(() => ReceivedRepository());

    // Global background controller for receiving sockets (Server)
    Get.put<ReceivedController>(
      ReceivedController(),
      permanent: true,
    );
  }
}
