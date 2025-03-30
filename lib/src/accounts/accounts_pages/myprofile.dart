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
                                        right: 10,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
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
