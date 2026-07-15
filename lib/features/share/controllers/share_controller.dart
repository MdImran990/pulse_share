import 'package:get/get.dart';

import '../../../core/services/socket_service.dart';
import '../../../data/models/peer_model.dart';
import '../../../data/repository/share_repository.dart';

class ShareController extends GetxController {
  final ShareRepository _repository = ShareRepository();
  final SocketService _socketService = SocketService();

  // Loading
  RxBool isLoading = false.obs;

  // Nearby Devices
  RxList<PeerModel> peers = <PeerModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    discoverPeers();
  }

  /// Discover Nearby Devices
  Future<void> discoverPeers() async {
    try {
      isLoading.value = true;

      peers.value = await _repository.discoverPeers();
    } catch (e) {
      Get.snackbar(
        "Discovery Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Send Pulse Data
  Future<void> sharePulse({
    required PeerModel peer,
    required Map<String, dynamic> pulseData,
  }) async {
    try {
      await _socketService.sendData(
        ip: peer.ip,
        port: peer.port,
        data: pulseData,
      );

      Get.snackbar(
        "Success",
        "Pulse data shared successfully.",
      );
    } catch (e) {
      Get.snackbar(
        "Share Failed",
        e.toString(),
      );
    }
  }

  /// Start Socket Server
  Future<void> startServer({
    required Function(Map<String, dynamic>) onReceive,
  }) async {
    try {
      await _socketService.startServer(
        onData: onReceive,
      );
    } catch (e) {
      Get.snackbar(
        "Server Error",
        e.toString(),
      );
    }
  }

  /// Stop Server
  Future<void> stopServer() async {
    await _socketService.stopServer();
  }

  @override
  void onClose() {
    stopServer();
    super.onClose();
  }
}