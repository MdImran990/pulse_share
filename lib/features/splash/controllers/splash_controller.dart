import 'dart:async';

import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();

    _goToDashboard();
  }

  void _goToDashboard() {

    Timer(
      const Duration(seconds: 2),
          () {
        Get.offNamed(AppRoutes.dashboard);
      },
    );

  }

}