import 'package:get/get.dart';

import '../../core/services/battery_service.dart';
import '../../core/services/device_service.dart';
import '../../data/repository/dashboard_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<BatteryService>(() => BatteryService());
    Get.lazyPut<DeviceService>(() => DeviceService());

    // Repository
    Get.lazyPut<DashboardRepository>(
          () => DashboardRepository(),
    );
  }
}