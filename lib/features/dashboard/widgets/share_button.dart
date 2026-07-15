import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: () {
            Get.toNamed(AppRoutes.share);
          },
          icon: const Icon(Icons.send),
          label: const Text(
            "Share My Pulse",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}