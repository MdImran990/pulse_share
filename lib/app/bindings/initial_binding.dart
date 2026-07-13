import 'package:get/get.dart';

import '../../core/services/battery_service.dart';
import '../../core/services/device_service.dart';
import '../../core/services/discovery_service.dart';
import '../../core/services/sensor_service.dart';
import '../../core/services/socket_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/telephony_service.dart';
import '../../core/services/wifi_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BatteryService>(() => BatteryService(), fenix: true);

    Get.lazyPut<DeviceService>(() => DeviceService(), fenix: true);

    Get.lazyPut<SensorService>(() => SensorService(), fenix: true);

    Get.lazyPut<WifiService>(() => WifiService(), fenix: true);

    Get.lazyPut<TelephonyService>(() => TelephonyService(), fenix: true);

    Get.lazyPut<SocketService>(() => SocketService(), fenix: true);

    Get.lazyPut<DiscoveryService>(() => DiscoveryService(), fenix: true);

    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
  }
}