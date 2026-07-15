import '../../data/models/sensor_info_model.dart';
import '../platform/sensor_platform.dart';

class SensorService {
  final SensorPlatform _sensorPlatform = SensorPlatform();

  Future<SensorInfoModel> getSensorInfo() async {
    final result = await _sensorPlatform.getSensorInfo();

    return SensorInfoModel(
      stepCount: result["stepCount"].toString(),
      activity: result["activity"].toString(),
    );
  }
}