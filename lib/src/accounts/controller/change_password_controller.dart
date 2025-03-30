import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode oldPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  final RxBool isLoading = false.obs;
  final RxString oldPasswordError = ''.obs;
  final RxString newPasswordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;
  
  // Password visibility states
  final RxBool isOldPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    oldPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  // Password visibility toggle methods
  void toggleOldPasswordVisibility() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool validateOldPassword(String value) {
    if (value.isEmpty) {
      oldPasswordError.value = 'Old password is required';
      return false;
    }
    oldPasswordError.value = '';
    return true;
  }

  bool validateNewPassword(String value) {
    if (value.isEmpty) {
      newPasswordError.value = 'New password is required';
      return false;
    }
    if (value.length < 6) {
      newPasswordError.value = 'Password must be at least 6 characters';
      return false;
    }
    newPasswordError.value = '';
    return true;
  }

  bool validateConfirmPassword(String value) {
    if (value.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      return false;
    }
    if (value != newPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      return false;
    }
    confirmPasswordError.value = '';
    return true;
  }

  bool validateAllFields() {
    bool isValid = true;
    isValid &= validateOldPassword(oldPasswordController.text);
    isValid &= validateNewPassword(newPasswordController.text);
    isValid &= validateConfirmPassword(confirmPasswordController.text);
    return isValid;
  }

  Future<void> changePassword() async {
    if (!validateAllFields()) {
      return;
    }

    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // First reauthenticate user with old password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);

        // Then update password
        await user.updatePassword(newPasswordController.text);

        // Clear fields
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        Get.snackbar(
          'Success',
          'Password updated successfully',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to update password';
      if (e.code == 'wrong-password') {
        message = 'Old password is incorrect';
      } else if (e.code == 'weak-password') {
        message = 'New password is too weak';
      }
      Get.snackbar(
        'Error',
        message,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error changing password: $e');
      Get.snackbar(
        'Error',
        'Failed to update password',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 