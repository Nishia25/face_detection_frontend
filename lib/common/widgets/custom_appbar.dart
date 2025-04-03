import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision_intelligence/common/controller/userdata_controller.dart';

import '../utils/upload_image.dart';

class CustomAppbar extends StatefulWidget {
  final IconData? icon;
  final VoidCallback? onPressed;
  const CustomAppbar({super.key, this.icon, this.onPressed});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  UserdataController userdataController = Get.put(UserdataController());
  final UploadImage _uploadImage = UploadImage();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId != null) {
      String? savedPath = _uploadImage.getSavedProfileImage(userId);
      if (savedPath != null && File(savedPath).existsSync()) {
        if (mounted) {
          setState(() {
            imagePath = savedPath;
          });
        }
      } else {
        debugPrint("Saved profile image not found.");
      }
    } else {
      debugPrint("User ID not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {  // 🔹 Obx ke andar wrap kar diya hai
              return CircleAvatar(
                radius: 40,
                backgroundImage: (userdataController.userProfileImage.value.isNotEmpty &&
                    File(userdataController.userProfileImage.value).existsSync())
                    ? FileImage(File(userdataController.userProfileImage.value))
                    : null,
                backgroundColor: Colors.grey[300],
                child: (userdataController.userProfileImage.value.isEmpty ||
                    !File(userdataController.userProfileImage.value).existsSync())
                    ? const Icon(Icons.camera_alt, color: Colors.white)
                    : null,
              );
            }),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Text(
                  userdataController.userName.value,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                )),
                const SizedBox(height: 5),
                Obx(() => Text(
                  userdataController.userVehicle.value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                )),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: widget.onPressed,
              icon: Icon(
                widget.icon,
                size: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
