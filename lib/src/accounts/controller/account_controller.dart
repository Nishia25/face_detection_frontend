import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vision_intelligence/firebase/request_permission.dart';
import 'package:vision_intelligence/src/auth/view/signin_screen.dart';

class AccountController extends GetxController{
  final notificationservice = NotificationService();
  RxBool lights = true.obs;

  void initNotificationSwitch() async {
    lights.value = await notificationservice.isNotificationPermissionGranted();
  }

  Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.notification.status;
      if (!status.isGranted) {
        status = await Permission.notification.request();
      }
      return status.isGranted;
    } else if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return false;
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await Get.deleteAll();
      Get.off(SignInScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}