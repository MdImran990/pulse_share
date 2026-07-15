import 'package:get/get.dart';

import '../../../core/services/socket_service.dart';
import '../../../data/repository/received_repository.dart';

class ReceivedController extends GetxController {
  final ReceivedRepository _repository =
  ReceivedRepository();

  final SocketService _socketService =
  SocketService();

  RxList<Map<String, dynamic>> receivedList =
      <Map<String, dynamic>>[].obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    loadReceivedData();

    startListening();
  }

  void loadReceivedData() {
    receivedList.value =
        _repository.getAllReceivedData();
  }

  Future<void> startListening() async {
    await _socketService.startServer(
      onData: (data) {
        _repository.saveReceivedData(data);

        loadReceivedData();

        Get.snackbar(
          "New Pulse",
          "Data received successfully",
        );
      },
    );
  }

  void clearAll() {
    _repository.clearAll();

    loadReceivedData();
  }

  @override
  void onClose() {
    _socketService.stopServer();

    super.onClose();
  }
}