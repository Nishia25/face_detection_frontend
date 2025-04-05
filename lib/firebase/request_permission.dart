import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 🔹 Request permission for notifications
  NotificationSettings settings = await messaging.requestPermission(
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

  // 🔹 Listen for token refresh and update it
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    updateFCMToken(newToken);
  });

  // 🔹 Handle messages when app is in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 Foreground notification received: ${message.notification?.title}");
  });

  // 🔹 Handle when notification is tapped while app is in background/terminated
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🔔 Notification clicked: ${message.notification?.title}");
  });

  await updateFCMToken();
}

// 🔹 Function to update FCM token in Firestore (only after login)
Future<void> updateFCMToken([String? newToken]) async {
  String? token = newToken ?? await FirebaseMessaging.instance.getToken();
  if (token == null) {
    print("❌ No FCM token received");
    return;
  }

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("❌ No logged-in user. Cannot save FCM token.");
    return;
  }

  String userId = user.uid;
  DocumentReference userDoc =
  FirebaseFirestore.instance.collection('users').doc(userId);

  // 🔹 Store token in Firestore (only update if it's different)
  DocumentSnapshot userSnapshot = await userDoc.get();
  Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

  String? storedToken = userData != null && userData.containsKey('fcmToken')
      ? userData['fcmToken']
      : null;

  if (storedToken == token) {
    print("ℹ️ Token is the same, no need to update.");
    print("FCM token: $token");
    return;
  }

  await userDoc.set({'fcmToken': token}, SetOptions(merge: true));
  print("✅ FCM Token stored in Firestore: $token");
}
