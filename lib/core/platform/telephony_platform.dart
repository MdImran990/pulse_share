import 'package:flutter/services.dart';

class TelephonyPlatform {
  static const MethodChannel _channel = MethodChannel("pulse_share/native");

  Future<Map<String, String>> getSimInfo() async {
    try {
      final result = await _channel.invokeMethod("getSimInfo");
      if (result == null) return {};
      return Map<String, String>.from(result);
    } catch (e) {
      return {
        "carrierName": "Error",
        "simState": "Unknown",
        "signalStrength": "--"
      };
    }
  }
}
