import 'package:get/get.dart';

import '../../../core/services/socket_service.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/repository/received_repository.dart';

class ReceivedController extends GetxController {
  final ReceivedRepository _repository = ReceivedRepository();
  final SocketService _socketService = SocketService();

  final RxList<Map<String, dynamic>> receivedList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReceivedData();
    startListening();
  }

  /// Load all received snapshots from local Hive database
  void loadReceivedData() {
    try {
      receivedList.value = _repository.getAllReceivedData();
      AppLogger.info("Loaded ${receivedList.length} snapshots from Hive.");
    } catch (e) {
      AppLogger.error("Failed to load received snapshots: $e");
    }
  }

  /// Start the TCP Server Socket to listen for incoming pulse shares
  Future<void> startListening() async {
    try {
      await _socketService.startServer(
        onData: (data) async {
          AppLogger.info("Received socket payload: $data");
          
          // Save snapshot to local database (Hive)
          await _repository.saveReceivedData(data);
          
          // Reload the list reactively
          loadReceivedData();

          // Show elegant GetX notification
          Get.snackbar(
            "New Pulse Received",
            "Snapshot saved locally from ${data["deviceName"] ?? "Unknown Device"}.",
            snackPosition: SnackPosition.TOP,
          );
        },
      );
      AppLogger.info("TCP socket server started listening on port 4040.");
    } catch (e) {
      AppLogger.error("Error starting TCP server socket: $e");
      Get.snackbar(
        "Server Connection Error",
        "Could not start the background socket server on port 4040. Make sure the port is not in use.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Clear all saved snapshots from Hive
  Future<void> clearAll() async {
    try {
      await _repository.clearAll();
      loadReceivedData();
      Get.snackbar(
        "History Cleared",
        "All received snapshots have been deleted.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      AppLogger.error("Failed to clear snapshots: $e");
    }
  }

  @override
  void onClose() {
    _socketService.stopServer();
    AppLogger.info("TCP socket server shut down.");
    super.onClose();
  }
}
