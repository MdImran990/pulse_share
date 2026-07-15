import 'package:get/get.dart';

import '../../features/dashboard/bindings/dashboard_binding.dart';
import '../../features/dashboard/views/dashboard_screen.dart';
import '../../features/received/bindings/received_binding.dart';
import '../../features/received/views/received_screen.dart';
import '../../features/share/bindings/share_binding.dart';
import '../../features/share/views/share_screen.dart';
import '../../features/splash/bindings/splash_binding.dart';
import '../../features/splash/views/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.share,
      page: () => const ShareScreen(),
      binding: ShareBinding(),
    ),
    GetPage(
      name: AppRoutes.received,
      page: () => const ReceivedScreen(),
      binding: ReceivedBinding(),
    ),
  ];
}
