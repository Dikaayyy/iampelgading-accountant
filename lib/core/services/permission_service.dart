import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionService {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();

      if (androidVersion >= 30) {
        // Android 11+ (API 30+)
        // For Android 11+, request MANAGE_EXTERNAL_STORAGE for Downloads access
        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      } else if (androidVersion >= 23) {
        // Android 6+ (API 23+)
        // For Android 6-10, use legacy storage permission
        final status = await Permission.storage.request();
        return status.isGranted;
      } else {
        // For older Android versions, no permission needed
        return true;
      }
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit permission for app documents
      return true;
    }

    return false;
  }

  static Future<bool> checkStoragePermission() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();

      if (androidVersion >= 30) {
        // Android 11+ (API 30+)
        return await Permission.manageExternalStorage.isGranted;
      } else if (androidVersion >= 23) {
        // Android 6+ (API 23+)
        return await Permission.storage.isGranted;
      } else {
        return true;
      }
    } else if (Platform.isIOS) {
      return true;
    }

    return false;
  }

  static Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  // Fix: Use the correct openAppSettings from permission_handler package
  static Future<void> openAppSettings() async {
    await Permission.manageExternalStorage.request();
    if (!(await Permission.manageExternalStorage.isGranted)) {
      await openAppSettings();
    }
  }
}
