import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserdataController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Create observable variables for user data
  var userName = "".obs;
  var userEmail = "".obs;
  var userPhone = "".obs;
  var userAddress = "".obs;
  var userVehicle = "".obs;
  var userProfileImage = "".obs;
  String? userId = "";// 🔹 Add this


  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void updateProfileImage(String path) {
    userProfileImage.value = path;  // Observable update
    saveProfileImagePath(path);  // Path save karna ensure karo
    fetchUserData();
  }

  Future<void> saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
    if (userId != null) {
      await prefs.setString('profile_image_$userId', path);
    }
  }


  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) {
        log("No user ID found in SharedPreferences");
        return;
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(
          userId).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;

        userName.value = data['name'] ?? "No Name";
        userEmail.value = data['email'] ?? "No Email";
        userPhone.value = data['phone'] ?? "No Phone";
        userAddress.value = data['address'] ?? "No Address";
        userVehicle.value = data['vehicleNo'] ?? "Not Register";

        // 🔹 Fetch profile image from Firestore
        String? firestoreImage = data['profileImageUrl'];

        // 🔹 Fetch from local storage if Firestore image is null
        String? localImage = prefs.getString('profile_image_$userId');

        userProfileImage.value = firestoreImage ?? localImage ?? "";

        log("User Data: Name: ${userName.value}, Email: ${userEmail.value}");
      } else {
        log("User document does not exist.");
      }
    } catch (e) {
      log("Error fetching user data: $e");
    }
  }
}