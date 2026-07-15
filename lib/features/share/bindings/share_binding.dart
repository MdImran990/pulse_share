import 'package:get/get.dart';

import '../../../../data/repository/share_repository.dart';
import '../controllers/share_controller.dart';

class ShareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareRepository>(() => ShareRepository());
    Get.lazyPut<ShareController>(() => ShareController());
  }
}
