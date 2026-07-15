import 'package:get/get.dart';

import '../../../../data/repository/received_repository.dart';
import '../controllers/received_controller.dart';

class ReceivedBinding extends Bindings {
  @override
  void dependencies() {
    // ReceivedRepository is already registered in InitialBinding,
    // and ReceivedController is already registered globally as permanent,
    // so we don't need to re-register them, but we declare the binding for routing safety.
    if (!Get.isRegistered<ReceivedRepository>()) {
      Get.lazyPut<ReceivedRepository>(() => ReceivedRepository());
    }
    if (!Get.isRegistered<ReceivedController>()) {
      Get.lazyPut<ReceivedController>(() => ReceivedController());
    }
  }
}
