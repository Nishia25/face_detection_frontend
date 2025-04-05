// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static void initialize(BuildContext context) {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//
//     _notificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (payload) {
//         // handle notification tap if needed
//       },
//     );
//   }
//
//   static void showNotification(RemoteMessage message) {
//     final notification = message.notification;
//     final android = message.notification?.android;
//
//     if (notification != null && android != null) {
//       final androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'high_importance_channel', // ID (must match AndroidManifest if declared)
//         'High Importance Notifications',
//         importance: Importance.max,
//         priority: Priority.high,
//       );
//
//       final platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//
//       _notificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         platformChannelSpecifics,
//       );
//     }
//   }
// }
