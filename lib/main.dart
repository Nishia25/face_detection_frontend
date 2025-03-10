import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vision_intelligence/common/controller/userdata_controller.dart';
import 'package:vision_intelligence/firebase/request_permission.dart';
import 'package:vision_intelligence/src/auth/service/auth_service.dart';
import 'package:vision_intelligence/src/auth/view/welcome_screen.dart';
import 'package:vision_intelligence/src/home/controller/home_controller.dart';
import 'package:vision_intelligence/src/home/view/home_dashboard.dart';
import 'package:vision_intelligence/src/main/controller/main_controller.dart';
import 'package:vision_intelligence/src/main/view/main_screen.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  requestPermission();

  final authService = AuthService();
  final bool isLoggedIn = await authService.isUserLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Vision Intelligence',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: AllControllerBinding(),
      scrollBehavior: CustomScrollBehavior(),
      home: isLoggedIn ? MainScreen() : WelcomeScreen(),
    );
  }
}

class AllControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => UserdataController());
    Get.lazyPut(() => HomeController());
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  // TODO: implement dragDevices
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
  };
}


