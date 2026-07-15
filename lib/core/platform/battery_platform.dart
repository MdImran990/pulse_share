import 'package:flutter/services.dart';

import '../../data/models/battery_info_model.dart';

class BatteryPlatform {
  static const MethodChannel _channel =
  MethodChannel("pulse_share/native");

  Future<BatteryInfoModel> getBatteryInfo() async {
    final result =
    await _channel.invokeMethod("getBatteryInfo");

    return BatteryInfoModel.fromJson(result);
  }
}