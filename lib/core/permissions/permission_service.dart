import 'package:permission_handler/permission_handler.dart';
import '../utils/app_logger.dart';

class PermissionService {
  /// Request all required permissions for Pulse Share.
  Future<bool> requestAllPermissions() async {
    try {
      final statuses = await [
        Permission.location,
        Permission.phone,
        Permission.activityRecognition,
      ].request();

      final locationGranted = statuses[Permission.location]?.isGranted ?? false;
      final phoneGranted = statuses[Permission.phone]?.isGranted ?? false;
      final activityGranted = statuses[Permission.activityRecognition]?.isGranted ?? false;

      AppLogger.info(
        "Permissions Status -> Location: $locationGranted, Phone: $phoneGranted, Activity: $activityGranted",
      );

      return locationGranted && phoneGranted && activityGranted;
    } catch (e) {
      AppLogger.error("Failed to request permissions: $e");
      return false;
    }
  }

  /// Check if all required permissions are granted.
  Future<bool> hasAllPermissions() async {
    final locationGranted = await Permission.location.isGranted;
    final phoneGranted = await Permission.phone.isGranted;
    final activityGranted = await Permission.activityRecognition.isGranted;

    return locationGranted && phoneGranted && activityGranted;
  }
}
