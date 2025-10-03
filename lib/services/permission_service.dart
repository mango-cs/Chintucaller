import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  // Request notification permission (for Android 13+)
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  // Request phone permissions (for call handling)
  static Future<bool> requestPhonePermissions() async {
    final statuses = await [
      Permission.phone,
      Permission.microphone,
    ].request();

    return statuses[Permission.phone]!.isGranted &&
        statuses[Permission.microphone]!.isGranted;
  }

  // Request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // Request contacts permission
  static Future<bool> requestContactsPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  // Request SMS permissions (for spam detection)
  static Future<bool> requestSMSPermissions() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  // Request call log permissions
  static Future<Map<Permission, PermissionStatus>>
      requestCallLogPermissions() async {
    return await [
      Permission.phone,
    ].request();
  }

  // Request all permissions at once
  static Future<Map<Permission, PermissionStatus>>
      requestAllPermissions() async {
    return await [
      Permission.phone,
      Permission.microphone,
      Permission.contacts,
      Permission.notification,
      Permission.sms,
    ].request();
  }

  // Check if a specific permission is granted
  static Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  // Check all permissions status
  static Future<Map<String, bool>> checkAllPermissionsStatus() async {
    return {
      'notification': await isPermissionGranted(Permission.notification),
      'phone': await isPermissionGranted(Permission.phone),
      'microphone': await isPermissionGranted(Permission.microphone),
      'contacts': await isPermissionGranted(Permission.contacts),
      'sms': await isPermissionGranted(Permission.sms),
    };
  }

  // Open app settings if permission is permanently denied
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  // Show permission dialog with explanation
  static Future<bool> showPermissionDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onAllow,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Not Now', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
              onAllow();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFCDFF00),
              foregroundColor: Colors.black,
            ),
            child: Text('Allow'),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
