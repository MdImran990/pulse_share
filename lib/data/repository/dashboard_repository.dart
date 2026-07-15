import '../../core/services/battery_service.dart';
import '../../core/services/device_service.dart';
import '../../core/services/sensor_service.dart';
import '../../core/services/wifi_service.dart';

import '../models/battery_info_model.dart';
import '../models/device_info_model.dart';
import '../models/network_info_model.dart';
import '../models/sensor_info_model.dart';

class DashboardRepository {
  final BatteryService _batteryService = BatteryService();
  final DeviceService _deviceService = DeviceService();
  final WifiService _wifiService = WifiService();
  final SensorService _sensorService = SensorService();

  //Battery

  Future<BatteryInfoModel> getBatteryInfo() async {
    return await _batteryService.getBatteryInfo();
  }

  //Device

  Future<DeviceInfoModel> getDeviceInfo() async {
    return await _deviceService.getDeviceInfo();
  }

  // WiFi

  Future<NetworkInfoModel> getWifiInfo() async {
    return await _wifiService.getWifiInfo();
  }

  // Sensor

  Future<SensorInfoModel> getSensorInfo() async {
    return await _sensorService.getSensorInfo();
  }
}