import 'package:device_info_plus/device_info_plus.dart';

import '../../data/models/device_info_model.dart';

class DeviceService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<DeviceInfoModel> getDeviceInfo() async {
    final androidInfo = await _deviceInfoPlugin.androidInfo;

    return DeviceInfoModel(
      model: androidInfo.model,
      brand: androidInfo.brand,
      manufacturer: androidInfo.manufacturer,
      androidVersion: androidInfo.version.release,
    );
  }
}