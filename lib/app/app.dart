import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class PulseShareApp extends StatelessWidget {
  const PulseShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pulse Share',

      theme: AppTheme.lightTheme,

      initialBinding: InitialBinding(),

      initialRoute: AppRoutes.splash,

      getPages: AppPages.routes,
    );
  }
}