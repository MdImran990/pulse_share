class PulseModel {
  final String batteryLevel;
  final String batteryTemperature;
  final String batteryHealth;

  final String deviceModel;
  final String androidVersion;
  final String deviceName;

  final String wifiName;
  final String ipAddress;
  final String wifiSignal;

  final String stepCount;
  final String activity;

  PulseModel({
    required this.batteryLevel,
    required this.batteryTemperature,
    required this.batteryHealth,
    required this.deviceModel,
    required this.androidVersion,
    required this.deviceName,
    required this.wifiName,
    required this.ipAddress,
    required this.wifiSignal,
    required this.stepCount,
    required this.activity,
  });

  Map<String, dynamic> toJson() {
    return {
      "batteryLevel": batteryLevel,
      "batteryTemperature": batteryTemperature,
      "batteryHealth": batteryHealth,
      "deviceModel": deviceModel,
      "androidVersion": androidVersion,
      "deviceName": deviceName,
      "wifiName": wifiName,
      "ipAddress": ipAddress,
      "wifiSignal": wifiSignal,
      "stepCount": stepCount,
      "activity": activity,
    };
  }

  factory PulseModel.fromJson(Map<String, dynamic> json) {
    return PulseModel(
      batteryLevel: json["batteryLevel"] ?? "",
      batteryTemperature: json["batteryTemperature"] ?? "",
      batteryHealth: json["batteryHealth"] ?? "",
      deviceModel: json["deviceModel"] ?? "",
      androidVersion: json["androidVersion"] ?? "",
      deviceName: json["deviceName"] ?? "",
      wifiName: json["wifiName"] ?? "",
      ipAddress: json["ipAddress"] ?? "",
      wifiSignal: json["wifiSignal"] ?? "",
      stepCount: json["stepCount"] ?? "",
      activity: json["activity"] ?? "",
    );
  }
}