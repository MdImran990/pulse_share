import 'package:flutter/services.dart';

class WifiPlatform {
  static const MethodChannel _channel = MethodChannel("pulse_share/native");

  Future<String> getWifiRssi() async {
    try {
      final result = await _channel.invokeMethod("getWifiRssi");
      return result ?? "--";
    } catch (e) {
      return "--";
    }
  }
}
