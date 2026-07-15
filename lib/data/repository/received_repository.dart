import 'package:get/get.dart';
import '../../core/services/storage_service.dart';

class ReceivedRepository {
  final StorageService _storageService = Get.find<StorageService>();

  /// Retrieves all received snapshots from Hive.
  List<Map<String, dynamic>> getAllReceivedData() {
    return _storageService.db.getAll();
  }

  /// Saves a newly received snapshot to Hive.
  Future<void> saveReceivedData(Map<String, dynamic> data) async {
    await _storageService.db.save(data);
  }

  /// Clears all snapshots in Hive.
  Future<void> clearAll() async {
    await _storageService.db.clearAll();
  }

  /// Gets the total count of received snapshots.
  int get totalReceived => _storageService.db.count;
}
