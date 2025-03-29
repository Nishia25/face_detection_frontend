import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';

import '../../../common/config/app_images.dart';
import '../../../common/utils/upload_image.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode vehicleFocusNode = FocusNode();

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();

  final UploadImage _uploadImage = UploadImage();
  File? _image;
  String? _imageUrl;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
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
          
          setState(() {
            _fnameController.text = data['name'] ?? '';
            _emailController.text = data['email'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _addressController.text = data['address'] ?? '';
            _vehicleController.text = data['vehicleNo'] ?? '';
            _imageUrl = data['profileImageUrl'];
          });

          // Load profile image from Hive
          var box = await Hive.openBox('userBox');
          String? savedPath = box.get('profile_image_$userId');
          if (savedPath != null) {
            setState(() {
              _image = File(savedPath);
            });
          }
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      File? imageFile = await _uploadImage.pickImage();
      if (imageFile != null) {
        setState(() {
          _image = imageFile;
          _isLoading = true;
        });

        // Upload image to Firebase Storage
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('user_id');
        
        if (userId != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child('$userId.jpg');

          await storageRef.putFile(_image!);
          final downloadUrl = await storageRef.getDownloadURL();

          // Update Firestore with new image URL
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'profileImageUrl': downloadUrl});

          // Save locally in Hive
          var box = await Hive.openBox('userBox');
          await box.put('profile_image_$userId', _image!.path);

          setState(() {
            _imageUrl = downloadUrl;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'name': _fnameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'vehicleNo': _vehicleController.text.trim(),
          'updatedAt': Timestamp.now(),
        });

        setState(() {
          _isEditing = false;
          _isLoading = false;
        });

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error updating user data: $e');
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    addressFocusNode.dispose();
    vehicleFocusNode.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Profile"),
          actions: [
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed: () {
                if (_isEditing) {
                  _updateUserData();
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(237, 29, 36, 1),
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _isEditing ? _pickAndUploadImage : null,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : (_imageUrl != null
                                          ? NetworkImage(_imageUrl!) as ImageProvider
                                          : null),
                                  backgroundColor: Colors.grey[300],
                                  child: (_image == null && _imageUrl == null)
                                      ? const Icon(Icons.camera_alt, color: Colors.white)
                                      : null,
                                  radius: 70.5,
                                ),
                                if (_isEditing)
                                  Positioned(
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
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: _fnameController,
                            focusNode: firstNameFocusNode,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            focusNode: emailFocusNode,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _phoneController,
                            focusNode: phoneFocusNode,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _addressController,
                            focusNode: addressFocusNode,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _vehicleController,
                            focusNode: vehicleFocusNode,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'Vehicle Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
