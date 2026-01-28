import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app.dart';
import 'services/notification/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermissions();

    // Initialize notification service
    await NotificationService().initialize();
  } catch (e) {
    // Log error but don't crash - app can still run without notifications
    debugPrint('Error initializing Firebase/notifications: $e');
  }

  runApp(const QiamApp());
}

Future<void> _requestPermissions() async {
  // Request location permission for prayer times and Qibla
  final locationStatus = await Permission.location.status;
  if (locationStatus.isDenied) {
    await Permission.location.request();
  }

  // Request notification permission (Android 13+)
  final notificationStatus = await Permission.notification.status;
  if (notificationStatus.isDenied) {
    await Permission.notification.request();
  }
}
