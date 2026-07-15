import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/utils/app_logger.dart';

class HiveDatabase {
  static const String boxName = "received_pulses_box";
  late Box<Map> _box;

  /// Initialize Hive Box
  Future<void> init() async {
    try {
      _box = await Hive.openBox<Map>(boxName);
      AppLogger.info("Hive database initialized. Opened box: $boxName");
    } catch (e, stack) {
      AppLogger.error("Failed to open Hive Box: $e", error: e, stackTrace: stack);
      // Fallback: Clear/reopen box in case of corruption
      await Hive.deleteBoxFromDisk(boxName);
      _box = await Hive.openBox<Map>(boxName);
    }
  }

  /// Get all snapshots
  List<Map<String, dynamic>> getAll() {
    try {
      return _box.values.map((val) {
        return Map<String, dynamic>.from(val);
      }).toList();
    } catch (e) {
      AppLogger.error("Error reading from Hive: $e");
      return [];
    }
  }

  /// Save snapshot
  Future<void> save(Map<String, dynamic> data) async {
    try {
      final key = DateTime.now().millisecondsSinceEpoch.toString();
      // Add a timestamp so we know when it was received
      final dataWithTimestamp = Map<String, dynamic>.from(data);
      dataWithTimestamp["receivedAt"] = DateTime.now().toIso8601String();
      
      await _box.put(key, dataWithTimestamp);
      AppLogger.info("Saved pulse snapshot to Hive with key: $key");
    } catch (e) {
      AppLogger.error("Error saving to Hive: $e");
    }
  }

  /// Clear all snapshots
  Future<void> clearAll() async {
    try {
      await _box.clear();
      AppLogger.info("Cleared all pulse snapshots from Hive.");
    } catch (e) {
      AppLogger.error("Error clearing Hive: $e");
    }
  }

  /// Get count
  int get count => _box.length;
}
