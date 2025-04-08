import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vision_intelligence/src/home/controller/home_controller.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<bool> isNotificationPermissionGranted() async {
    if (Platform.isAndroid) {
      return await Permission.notification.isGranted;
    } else if (Platform.isIOS) {
      NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return false;
  }

  Future<void> requestPermissionAndInit() async {
    // 🔹 Request notification permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission for notifications');
    } else {
      print('❌ User declined or has not accepted permission');
      return;
    }

    // 🔹 Android 13+ notification permission
    if (Platform.isAndroid && await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // 🔹 Initialize local notification plugin
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _localNotifications.initialize(initSettings);

    // 🔹 Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground notification received: ${message.notification?.title}");
      _showLocalNotification(message);
      Get.find<HomeController>().incrementNotificationCount();
      final title = message.notification?.title ?? 'New Notification';
      Get.find<HomeController>().showNotificationTitle(title);
    });

    // 🔹 Background click handler
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔔 Notification clicked: ${message.notification?.title}");
    });

    // 🔹 Token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateFCMToken(newToken);
    });

    // 🔹 Get and store token
    await updateFCMToken();
    await registerFcmTokenWithBackend();
  }

  // 🔹 Show local notification when app is in foreground
  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      final androidDetails = AndroidNotificationDetails(
        'high_importance_channel', // must match channel in AndroidManifest
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      final notificationDetails = NotificationDetails(android: androidDetails);

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
      );
    }
  }

  // 🔹 Save token to Firestore
  Future<void> updateFCMToken([String? newToken]) async {
    final token = newToken ?? await FirebaseMessaging.instance.getToken();
    if (token == null) {
      print("❌ No FCM token received");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ No logged-in user. Cannot save FCM token.");
      return;
    }

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userSnapshot = await userDoc.get();
    final userData = userSnapshot.data() as Map<String, dynamic>?;

    final storedToken = userData?['fcmToken'];
    if (storedToken == token) {
      print("ℹ️ Token is the same, no need to update.");
      return;
    }

    await userDoc.set({'fcmToken': token}, SetOptions(merge: true));
    print("✅ FCM Token stored in Firestore: $token");
  }

  // 🔹 Register FCM token with backend
  Future<void> registerFcmTokenWithBackend() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        print("❌ Failed to get FCM token.");
        return;
      }

      print("📱 FCM Token: $token");

      final response = await http.post(
        Uri.parse('http://192.168.1.97:5000/register_token'), // 👈 your backend
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        print("✅ Token registered with backend.");
      } else {
        print("❌ Failed to register token: ${response.body}");
      }
    } catch (e) {
      print("❌ Error registering token: $e");
    }
  }
}
