class BatteryInfoModel {
  final int level;
  final double temperature;
  final String health;

  BatteryInfoModel({
    required this.level,
    required this.temperature,
    required this.health,
  });

  factory BatteryInfoModel.fromJson(Map<dynamic, dynamic> json) {
    return BatteryInfoModel(
      level: json['level'] ?? 0,
      temperature: (json['temperature'] ?? 0).toDouble(),
      health: json['health'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'temperature': temperature,
      'health': health,
    };
  }
}