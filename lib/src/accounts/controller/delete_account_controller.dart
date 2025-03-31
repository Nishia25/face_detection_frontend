import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision_intelligence/src/auth/view/signin_screen.dart';

class DeleteAccountController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> deleteAccount(BuildContext context) async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Delete user data from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        // Delete user account from Firebase Auth
        await user.delete();

        // Clear shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // Navigate to login screen
        Get.off(SignInScreen());
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to delete account';
      if (e.code == 'requires-recent-login') {
        message = 'Please log in again to delete your account.';
      }
      Get.snackbar(
        'Error',
        message,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error deleting account: $e');
      Get.snackbar(
        'Error',
        'An error occurred while deleting your account',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> showDeleteConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAccount(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
} 