import 'package:flutter/services.dart';

class PermissionService {
  static const MethodChannel _channel = MethodChannel('permission_channel');

  static Future<bool> requestPermission(String permission) async {
    try {
      final bool result = await _channel.invokeMethod('requestPermission', {
        'permission': permission,
      });
      return result;
    } catch (e) {
      print("Error requesting permission: $e");
      return false;
    }
  }
}
