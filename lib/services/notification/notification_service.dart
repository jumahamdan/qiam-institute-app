import 'dart:io';
import 'dart:ui' show Color;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService._showLocalNotification(message);
}

/// Service for handling push notifications via Firebase Cloud Messaging
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Notification channel for Android
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'qiam_notifications',
    'Qiam Institute Notifications',
    description: 'Notifications from Qiam Institute',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  // SharedPreferences keys
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyEventsEnabled = 'notifications_events';
  static const String _keyAnnouncementsEnabled = 'notifications_announcements';
  static const String _keyLiveEnabled = 'notifications_live';

  // Topic names
  static const String topicEvents = 'events';
  static const String topicAnnouncements = 'announcements';
  static const String topicLive = 'live';
  static const String topicAll = 'all';

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Set up local notifications
    await _setupLocalNotifications();

    // Request permission
    await requestPermission();

    // Set up message handlers
    _setupMessageHandlers();

    // Subscribe to default topics based on preferences
    await _syncTopicSubscriptions();

    _isInitialized = true;
  }

  /// Set up local notifications plugin
  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }
  }

  /// Handle notification tap
  static void _onNotificationTap(NotificationResponse response) {
    // Handle navigation based on payload
    final payload = response.payload;
    if (payload != null) {
      // TODO: Navigate to specific screen based on payload
      // e.g., if payload contains event ID, navigate to event detail
    }
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (granted) {
      // Token is available via getToken() method if needed for testing
      await _messaging.getToken();
    }

    return granted;
  }

  /// Set up FCM message handlers
  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background/terminated message tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check if app was opened from a terminated state via notification
    _checkInitialMessage();
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    await _showLocalNotification(message);
  }

  /// Handle when user taps notification (app in background)
  void _handleMessageOpenedApp(RemoteMessage message) {
    // TODO: Navigate to specific screen based on message data
    final data = message.data;
    if (data.containsKey('type')) {
      // Handle navigation based on notification type
    }
  }

  /// Check if app was opened from notification (terminated state)
  Future<void> _checkInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      _handleMessageOpenedApp(message);
    }
  }

  /// Show local notification
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: _channel.importance,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
      color: const Color(0xFF8224E3),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data['route'],
    );
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  /// Sync topic subscriptions based on user preferences
  Future<void> _syncTopicSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_keyNotificationsEnabled) ?? true;

    if (!enabled) {
      // Unsubscribe from all topics
      await unsubscribeFromTopic(topicAll);
      await unsubscribeFromTopic(topicEvents);
      await unsubscribeFromTopic(topicAnnouncements);
      await unsubscribeFromTopic(topicLive);
      return;
    }

    // Always subscribe to 'all' topic for important announcements
    await subscribeToTopic(topicAll);

    // Subscribe/unsubscribe based on preferences
    final eventsEnabled = prefs.getBool(_keyEventsEnabled) ?? true;
    if (eventsEnabled) {
      await subscribeToTopic(topicEvents);
    } else {
      await unsubscribeFromTopic(topicEvents);
    }

    final announcementsEnabled = prefs.getBool(_keyAnnouncementsEnabled) ?? true;
    if (announcementsEnabled) {
      await subscribeToTopic(topicAnnouncements);
    } else {
      await unsubscribeFromTopic(topicAnnouncements);
    }

    final liveEnabled = prefs.getBool(_keyLiveEnabled) ?? true;
    if (liveEnabled) {
      await subscribeToTopic(topicLive);
    } else {
      await unsubscribeFromTopic(topicLive);
    }
  }

  // Preferences getters/setters

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  /// Enable/disable all notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, enabled);
    await _syncTopicSubscriptions();
  }

  /// Check if events notifications are enabled
  Future<bool> areEventsNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyEventsEnabled) ?? true;
  }

  /// Enable/disable events notifications
  Future<void> setEventsNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEventsEnabled, enabled);
    if (enabled) {
      await subscribeToTopic(topicEvents);
    } else {
      await unsubscribeFromTopic(topicEvents);
    }
  }

  /// Check if announcements notifications are enabled
  Future<bool> areAnnouncementsNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAnnouncementsEnabled) ?? true;
  }

  /// Enable/disable announcements notifications
  Future<void> setAnnouncementsNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAnnouncementsEnabled, enabled);
    if (enabled) {
      await subscribeToTopic(topicAnnouncements);
    } else {
      await unsubscribeFromTopic(topicAnnouncements);
    }
  }

  /// Check if live notifications are enabled
  Future<bool> areLiveNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLiveEnabled) ?? true;
  }

  /// Enable/disable live notifications
  Future<void> setLiveNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLiveEnabled, enabled);
    if (enabled) {
      await subscribeToTopic(topicLive);
    } else {
      await unsubscribeFromTopic(topicLive);
    }
  }

  /// Get FCM token (useful for testing)
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}