// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:untitled/config/route/app_routes.dart';
//
// class NotificationService {
//   NotificationService._();
//
//   static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   static const String _channelId = 'high_importance_channel';
//   static const String _channelName = 'High Importance Notifications';
//   static const String _channelDescription = 'Used for important notifications';
//
//   /// Initialize local notifications
//   static Future<void> init() async {
//     await _requestAndroidPermission();
//     await _initializePlugin();
//     await _createAndroidChannel();
//   }
//
//   /// Request notification permission
//   static Future<void> _requestAndroidPermission() async {
//     final androidPlugin = _notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >();
//     await androidPlugin?.requestNotificationsPermission();
//   }
//
//   /// Initialize notification plugin
//   static Future<void> _initializePlugin() async {
//     const androidSettings = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     const iosSettings = DarwinInitializationSettings();
//     const settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//     await _notificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//     );
//   }
//
//   /// Handle notification tap
//   static void _onNotificationTap(NotificationResponse response) {
//     if (kDebugMode) {
//       debugPrint('Notification tapped: ${response.payload}');
//     }
//     Get.toNamed(AppRoutes.notifications);
//   }
//
//   /// Create Android notification channel
//   static Future<void> _createAndroidChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       _channelId,
//       _channelName,
//       description: _channelDescription,
//       importance: Importance.high,
//     );
//     final androidPlugin = _notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >();
//
//     await androidPlugin?.createNotificationChannel(channel);
//   }
//
//   /// Show notification
//   static Future<void> show({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     final notificationId = Random().nextInt(100000);
//     const androidDetails = AndroidNotificationDetails(
//       _channelId,
//       _channelName,
//       channelDescription: _channelDescription,
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _notificationsPlugin.show(
//       notificationId,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
// }
