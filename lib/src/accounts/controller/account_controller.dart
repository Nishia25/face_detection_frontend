import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountController extends GetxController{
  RxBool lights = false.obs;

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await Get.deleteAll();
      Get.offAllNamed('/login');
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