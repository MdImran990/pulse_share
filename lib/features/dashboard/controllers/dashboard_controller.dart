import 'package:get/get.dart';

import '../../../data/models/battery_info_model.dart';
import '../../../data/models/device_info_model.dart';
import '../../../data/models/network_info_model.dart';
import '../../../data/models/sensor_info_model.dart';
import '../../../data/repository/dashboard_repository.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository = DashboardRepository();

  // Loading
  final RxBool isLoading = false.obs;

  // ================= Battery =================

  final RxString batteryLevel = "--".obs;
  final RxString batteryTemp = "--".obs;
  final RxString batteryHealth = "--".obs;

  // ================= Device =================

  final RxString deviceModel = "--".obs;
  final RxString androidVersion = "--".obs;
  final RxString deviceName = "--".obs;

  // ================= Network =================

  final RxString wifiName = "--".obs;
  final RxString ipAddress = "--".obs;
  final RxString wifiSignal = "--".obs;

  // ================= Sensor =================

  final RxString stepCount = "0".obs;
  final RxString activity = "Unknown".obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  // ================= Load All =================

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      await Future.wait([
        loadBatteryInfo(),
        loadDeviceInfo(),
        loadWifiInfo(),
        loadSensorInfo(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= Battery =================

  Future<void> loadBatteryInfo() async {
    try {
      final BatteryInfoModel battery =
      await _repository.getBatteryInfo();

      batteryLevel.value = "${battery.level}%";
      batteryTemp.value = "${battery.temperature} °C";
      batteryHealth.value = battery.health;
    } catch (e) {
      Get.snackbar(
        "Battery Error",
        e.toString(),
      );
    }
  }

  // ================= Device =================

  Future<void> loadDeviceInfo() async {
    try {
      final DeviceInfoModel device =
      await _repository.getDeviceInfo();

      deviceModel.value = device.model;
      androidVersion.value =
      "Android ${device.androidVersion}";
      deviceName.value = device.brand;
    } catch (e) {
      Get.snackbar(
        "Device Error",
        e.toString(),
      );
    }
  }

  // ================= WiFi =================

  Future<void> loadWifiInfo() async {
    try {
      final NetworkInfoModel wifi =
      await _repository.getWifiInfo();

      wifiName.value = wifi.wifiName;
      ipAddress.value = wifi.ipAddress;
      wifiSignal.value = wifi.wifiSignal;
    } catch (e) {
      Get.snackbar(
        "WiFi Error",
        e.toString(),
      );
    }
  }

  // ================= Sensor =================

  Future<void> loadSensorInfo() async {
    try {
      final SensorInfoModel sensor =
      await _repository.getSensorInfo();

      stepCount.value = sensor.stepCount;
      activity.value = sensor.activity;
    } catch (e) {
      Get.snackbar(
        "Sensor Error",
        e.toString(),
      );
    }
  }

  // ================= Share Pulse Data =================

  Map<String, dynamic> getPulseData() {
    return {
      // Battery
      "batteryLevel": batteryLevel.value,
      "batteryTemperature": batteryTemp.value,
      "batteryHealth": batteryHealth.value,

      // Device
      "deviceModel": deviceModel.value,
      "androidVersion": androidVersion.value,
      "deviceName": deviceName.value,

      // Network
      "wifiName": wifiName.value,
      "ipAddress": ipAddress.value,
      "wifiSignal": wifiSignal.value,

      // Sensor
      "stepCount": stepCount.value,
      "activity": activity.value,
    };
  }

  // Refresh Dashboard

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }
}