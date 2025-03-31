import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vision_intelligence/src/auth/view/signin_screen.dart';

class AccountController extends GetxController{
  RxBool lights = false.obs;

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