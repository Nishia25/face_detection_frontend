import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_intelligence/common/config/app_images.dart';
import 'package:vision_intelligence/common/widgets/app_button.dart';
import 'package:vision_intelligence/src/auth/view/welcome_screen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade300,
              Colors.purple.shade300,
              Colors.orange.shade300,
            ], // Add more colors as needed
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(AppImages.welcomeimg), // Ensure the file exists
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Face Vision Intelligence",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
                const SizedBox(height: 40),
                AppButton(
                    onPressed: () => Get.to(WelcomeScreen()),
                    text: "Get Started")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
