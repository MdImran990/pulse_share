import 'package:get/get.dart';

import '../../../core/services/socket_service.dart';
import '../../../data/models/peer_model.dart';
import '../../../data/repository/share_repository.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class ShareController extends GetxController {
  final ShareRepository _repository = ShareRepository();
  final SocketService _socketService = SocketService();
  final DashboardController _dashboardController = Get.find<DashboardController>();

  // Loading
  RxBool isLoading = false.obs;

  // Nearby Devices
  RxList<PeerModel> peers = <PeerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _startNsd();
  }

  /// Start NSD service registration and discovery
  Future<void> _startNsd() async {
    try {
      isLoading.value = true;
      
      // Start peer discovery
      await _repository.startDiscovery();

      // Register this device so nearby peers can find us
      final deviceName = _dashboardController.deviceModel.value != "--"
          ? _dashboardController.deviceModel.value
          : "Android_Pulse";
      await _repository.registerMyDevice(deviceName, 4040);

      // Fetch currently discovered peers
      await discoverPeers();
    } catch (e) {
      Get.snackbar("NSD Error", "Failed to start network discovery: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Discover Nearby Devices (reads currently resolved peers from Kotlin)
  Future<void> discoverPeers() async {
    try {
      final list = await _repository.discoverPeers();
      // Filter out our own device by IP (if matching our current IP address)
      final myIp = _dashboardController.ipAddress.value;
      peers.value = list.where((p) => p.ip != myIp).toList();
    } catch (e) {
      Get.snackbar(
        "Discovery Error",
        e.toString(),
      );
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
        "Pulse data shared successfully to ${peer.name}.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Share Failed",
        "Could not connect to peer ${peer.name}. Make sure they have the app open. Error: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Start Socket Server (Not used here directly as ReceivedController handles receiving, but kept for interface completeness)
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
    _repository.stopDiscovery();
    _repository.unregisterMyDevice();
    stopServer();
    super.onClose();
  }
}
