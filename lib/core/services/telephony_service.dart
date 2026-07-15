import '../platform/telephony_platform.dart';

class TelephonyService {
  final TelephonyPlatform _telephonyPlatform = TelephonyPlatform();

  Future<Map<String, String>> getSimInfo() async {
    return await _telephonyPlatform.getSimInfo();
  }
}
