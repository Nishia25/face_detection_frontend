import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../../../common/utils/upload_image.dart';

class EditController extends GetxController {
  final UploadImage _uploadImage = UploadImage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
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
  final RxString currentEmail = ''.obs;

  // Validation error messages
  final RxString nameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString addressError = ''.obs;
  final RxString vehicleError = ''.obs;

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

  // Validation methods
  bool validateName(String value) {
    if (value.isEmpty) {
      nameError.value = 'Name is required';
      return false;
    }
    if (value.length < 2) {
      nameError.value = 'Name must be at least 2 characters';
      return false;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      nameError.value = 'Name can only contain letters and spaces';
      return false;
    }
    nameError.value = '';
    return true;
  }

  bool validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email is required';
      return false;
    }
    if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email';
      return false;
    }
    emailError.value = '';
    return true;
  }

  bool validatePhone(String value) {
    if (value.isEmpty) {
      phoneError.value = 'Phone number is required';
      return false;
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      phoneError.value = 'Please enter a valid 10-digit phone number';
      return false;
    }
    phoneError.value = '';
    return true;
  }

  bool validateAddress(String value) {
    if (value.isEmpty) {
      addressError.value = 'Address is required';
      return false;
    }
    if (value.length < 2) {
      addressError.value = 'Address must be at least 10 characters';
      return false;
    }
    addressError.value = '';
    return true;
  }

  bool validateVehicle(String value) {
    if (value.isEmpty) {
      vehicleError.value = 'Vehicle number is required';
      return false;
    }
    // Indian vehicle number format: XX-XX-XXXX or XX-XXXX-XXXX
    // if (!RegExp(r'^[A-Z]{2}[-\s]?[0-9]{2}[-\s]?[A-Z0-9]{4}$').hasMatch(value)) {
    //   vehicleError.value = 'Please enter a valid vehicle number';
    //   return false;
    // }
    vehicleError.value = '';
    return true;
  }

  bool validateAllFields() {
    bool isValid = true;
    
    isValid &= validateName(fnameController.text);
    isValid &= validateEmail(emailController.text);
    isValid &= validatePhone(phoneController.text);
    isValid &= validateAddress(addressController.text);
    isValid &= validateVehicle(vehicleController.text);
    
    return isValid;
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
          currentEmail.value = data['email'] ?? '';
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
    if (!validateAllFields()) {
      return;
    }

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId != null) {
        // Check if email has changed
        if (emailController.text.trim() != currentEmail.value) {
          // Show confirmation dialog
          bool? shouldProceed = await Get.dialog<bool>(
            AlertDialog(
              title: const Text('Email Change Required'),
              content: const Text(
                'To change your email, you will need to verify the new email address. '
                'A verification link will be sent to your new email. '
                'Please check your inbox and click the verification link before logging in again.'
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text('Proceed'),
                ),
              ],
            ),
          );

          if (shouldProceed != true) {
            isLoading.value = false;
            return;
          }

          // Update email in Firebase Authentication
          User? user = _auth.currentUser;
          if (user != null) {
            try {
              // First update the email in Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .update({
                'email': emailController.text.trim(),
                'emailVerified': false,
                'updatedAt': Timestamp.now(),
              });

              // Then send verification email
              await user.verifyBeforeUpdateEmail(emailController.text.trim());
              
              // Sign out the user
              await _auth.signOut();
              
              // Clear shared preferences
              await prefs.clear();
              
              Get.snackbar(
                'Verification Required',
                'Please check your new email for verification link. '
                'You will need to verify your email before logging in again.',
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.orange,
                snackPosition: SnackPosition.BOTTOM,
              );
              
              // Navigate to login screen
              Get.offAllNamed('/login');
              return;
            } catch (e) {
              print('Error during email update: $e');
              // Revert Firestore changes if verification fails
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .update({
                'email': currentEmail.value,
                'emailVerified': true,
                'updatedAt': Timestamp.now(),
              });
              throw e;
            }
          }
        }

        // Update other Firestore data
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'name': fnameController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'vehicleNo': vehicleController.text.trim(),
          'updatedAt': Timestamp.now(),
        });

        // Update current email
        currentEmail.value = emailController.text.trim();

        isEditing.value = false;
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error updating user data: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        duration: const Duration(seconds: 5),
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