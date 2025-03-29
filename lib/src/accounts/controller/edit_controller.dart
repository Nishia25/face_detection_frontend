import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import '../../../common/utils/upload_image.dart';

class EditController extends GetxController {
  final UploadImage _uploadImage = UploadImage();
  
  // Controllers
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();

  // Focus Nodes
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode vehicleFocusNode = FocusNode();

  // Observable variables
  final RxBool isEditing = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<File?> image = Rx<File?>(null);
  final RxString imageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    // Dispose controllers
    fnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    vehicleController.dispose();

    // Dispose focus nodes
    firstNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    addressFocusNode.dispose();
    vehicleFocusNode.dispose();

    super.onClose();
  }

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      
      if (userId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          
          fnameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['phone'] ?? '';
          addressController.text = data['address'] ?? '';
          vehicleController.text = data['vehicleNo'] ?? '';
          imageUrl.value = data['profileImageUrl'] ?? '';

          // Load profile image from Hive
          var box = await Hive.openBox('userBox');
          String? savedPath = box.get('profile_image_$userId');
          if (savedPath != null) {
            image.value = File(savedPath);
          }
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      File? imageFile = await _uploadImage.pickImage();
      if (imageFile != null) {
        isLoading.value = true;
        image.value = imageFile;

        // Upload image to Firebase Storage
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('user_id');
        
        if (userId != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child('$userId.jpg');

          await storageRef.putFile(imageFile);
          final downloadUrl = await storageRef.getDownloadURL();

          // Update Firestore with new image URL
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'profileImageUrl': downloadUrl});

          // Save locally in Hive
          var box = await Hive.openBox('userBox');
          await box.put('profile_image_$userId', imageFile.path);

          imageUrl.value = downloadUrl;
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar(
        'Error',
        'Failed to upload image',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'name': fnameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'vehicleNo': vehicleController.text.trim(),
          'updatedAt': Timestamp.now(),
        });

        isEditing.value = false;
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error updating user data: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEditMode() {
    isEditing.value = !isEditing.value;
  }
} 