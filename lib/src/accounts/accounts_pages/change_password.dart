import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_intelligence/common/widgets/appbar.dart';
import '../controller/change_password_controller.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangePasswordController controller = Get.put(ChangePasswordController());

    return Scaffold(
      appBar: Appbar(
        title: "Change Password",
        showBackButton: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(top: 10, bottom: 30),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      TextField(
                        controller: controller.oldPasswordController,
                        focusNode: controller.oldPasswordFocusNode,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          errorText: controller.oldPasswordError.value.isEmpty ? null : controller.oldPasswordError.value,
                        ),
                        onChanged: (value) => controller.validateOldPassword(value),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: controller.newPasswordController,
                        focusNode: controller.newPasswordFocusNode,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          errorText: controller.newPasswordError.value.isEmpty ? null : controller.newPasswordError.value,
                        ),
                        onChanged: (value) => controller.validateNewPassword(value),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: controller.confirmPasswordController,
                        focusNode: controller.confirmPasswordFocusNode,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          errorText: controller.confirmPasswordError.value.isEmpty ? null : controller.confirmPasswordError.value,
                        ),
                        onChanged: (value) => controller.validateConfirmPassword(value),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
          ),
        ),
      ),
    );
  }
}
