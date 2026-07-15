import 'package:flutter/services.dart';

class SensorPlatform {
  static const MethodChannel _channel =
  MethodChannel("pulse_share/native");

  Future<Map<dynamic, dynamic>> getSensorInfo() async {
    final result =
    await _channel.invokeMethod("getSensorInfo");

    return result;
  }
}