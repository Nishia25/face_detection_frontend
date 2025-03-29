import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import '../controller/edit_controller.dart';
import '../../../common/widgets/appbar.dart';

import '../../../common/config/app_images.dart';
import '../../../common/utils/upload_image.dart';

class Myprofile extends StatelessWidget {
  const Myprofile({super.key});

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
            color: Colors.grey[700],
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
                                Obx(() => CircleAvatar(
                                  backgroundImage: controller.image.value != null
                                      ? FileImage(controller.image.value!)
                                      : (controller.imageUrl.value.isNotEmpty
                                          ? NetworkImage(controller.imageUrl.value) as ImageProvider
                                          : null),
                                  backgroundColor: Colors.grey[300],
                                  radius: 70.5,
                                  child: (controller.image.value == null && controller.imageUrl.value.isEmpty)
                                      ? const Icon(Icons.camera_alt, color: Colors.white)
                                      : null,
                                )),
                                Obx(() => controller.isEditing.value
                                    ? Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Obx(() => TextField(
                            controller: controller.fnameController,
                            focusNode: controller.firstNameFocusNode,
                            enabled: controller.isEditing.value,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              border: OutlineInputBorder(),
                            ),
                          )),
                          const SizedBox(height: 8),
                          Obx(() => TextField(
                            controller: controller.emailController,
                            focusNode: controller.emailFocusNode,
                            enabled: controller.isEditing.value,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          )),
                          const SizedBox(height: 8),
                          Obx(() => TextField(
                            controller: controller.phoneController,
                            focusNode: controller.phoneFocusNode,
                            enabled: controller.isEditing.value,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(),
                            ),
                          )),
                          const SizedBox(height: 8),
                          Obx(() => TextField(
                            controller: controller.addressController,
                            focusNode: controller.addressFocusNode,
                            enabled: controller.isEditing.value,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                          )),
                          const SizedBox(height: 8),
                          Obx(() => TextField(
                            controller: controller.vehicleController,
                            focusNode: controller.vehicleFocusNode,
                            enabled: controller.isEditing.value,
                            decoration: const InputDecoration(
                              labelText: 'Vehicle Number',
                              border: OutlineInputBorder(),
                            ),
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
