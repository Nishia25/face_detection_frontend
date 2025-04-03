import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision_intelligence/common/controller/userdata_controller.dart';
import '../../../common/utils/hive_helper.dart';
import '../../../common/utils/upload_image.dart';
import '../controller/edit_controller.dart';
import '../../../common/widgets/appbar.dart';


class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  UserdataController userdataController = Get.put(UserdataController());
  final UploadImage _uploadImage = UploadImage();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    userdataController.fetchUserData(); // Ensure local & Firestore image loads
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

    final EditController controller = Get.put(EditController());

    return SafeArea(
      child: Scaffold(
        appBar: Appbar(
          title: "My Profile",
          showBackButton: true,
          reactiveIcon: Obx(() => Icon(
            controller.isEditing.value ? Icons.save : Icons.edit,
            color: Colors.white,
          )),
          onIconPressed: () {
            if (controller.isEditing.value) {
              controller.updateUserData();
            } else {
              controller.toggleEditMode();
            }
          },
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
            child: Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: controller.isEditing.value ? controller.pickAndUploadImage : null,
                            child: Stack(
                              children: [
                                Obx(() {
                                  String? localImagePath = HiveHelper().getSavedProfileImage(userdataController.userId ??"");
                                  return CircleAvatar(
                                    backgroundImage: (userdataController.userProfileImage.value.isNotEmpty &&
                                        File(userdataController.userProfileImage.value).existsSync())
                                        ? FileImage(File(userdataController.userProfileImage.value))
                                        : null,
                                    backgroundColor: Colors.grey[300],
                                    radius: 70.5,
                                    child: (userdataController.userProfileImage.value.isEmpty ||
                                        !File(userdataController.userProfileImage.value).existsSync())
                                        ? const Icon(Icons.camera_alt, color: Colors.white)
                                        : null,
                                  );
                                }),
                                Obx(() => controller.isEditing.value
                                    ? Positioned(
                                  bottom: 0,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                )
                                    : const SizedBox.shrink()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: controller.emailController,
                                focusNode: controller.emailFocusNode,
                                enabled: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.email),
                                  errorText: controller.emailError.value.isEmpty ? null : controller.emailError.value,
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextField(
                                controller: controller.fnameController,
                                focusNode: controller.firstNameFocusNode,
                                enabled: controller.isEditing.value,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  border: const OutlineInputBorder(),
                                  errorText: controller.nameError.value.isEmpty ? null : controller.nameError.value,
                                ),
                                onChanged: (value) => controller.validateName(value),
                              ),
                              const SizedBox(height: 18),
                              TextField(
                                controller: controller.phoneController,
                                focusNode: controller.phoneFocusNode,
                                enabled: controller.isEditing.value,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Phone',
                                  border: const OutlineInputBorder(),
                                  errorText: controller.phoneError.value.isEmpty ? null : controller.phoneError.value,
                                ),
                                onChanged: (value) => controller.validatePhone(value),
                              ),
                              const SizedBox(height: 18),
                              TextField(
                                controller: controller.addressController,
                                focusNode: controller.addressFocusNode,
                                enabled: controller.isEditing.value,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                  border: const OutlineInputBorder(),
                                  errorText: controller.addressError.value.isEmpty ? null : controller.addressError.value,
                                ),
                                onChanged: (value) => controller.validateAddress(value),
                              ),
                              const SizedBox(height: 18),
                              TextField(
                                controller: controller.vehicleController,
                                focusNode: controller.vehicleFocusNode,
                                enabled: controller.isEditing.value,
                                textCapitalization: TextCapitalization.characters,
                                decoration: InputDecoration(
                                  labelText: 'Vehicle Number',
                                  border: const OutlineInputBorder(),
                                  errorText: controller.vehicleError.value.isEmpty ? null : controller.vehicleError.value,
                                  hintText: 'XX-XX-XXXX or XX-XXXX-XXXX',
                                ),
                                onChanged: (value) => controller.validateVehicle(value),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  )),
          ),
        ),
      ),
    );
  }
}
