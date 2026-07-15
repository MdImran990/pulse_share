import '../../data/models/battery_info_model.dart';
import '../platform/battery_platform.dart';

class BatteryService {
  final BatteryPlatform _platform =
  BatteryPlatform();

  Future<BatteryInfoModel> getBatteryInfo() {
    return _platform.getBatteryInfo();
  }
}