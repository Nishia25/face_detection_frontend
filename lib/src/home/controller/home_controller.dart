import 'dart:developer';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Create observable variables for user data
  var userName = "".obs;
  var userEmail = "".obs;
  var userPhone = "".obs;
  var profilePic = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id'); // Retrieve user ID from SharedPreferences

      if (userId == null) {
        log("No user ID found in SharedPreferences");
        return;
      }

      // 🔹 Fetch user data from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;

        // 🔹 Store data in variables
        userName.value = data['name'] ?? "No Name";
        userEmail.value = data['email'] ?? "No Email";
        userPhone.value = data['phone'] ?? "No Phone";
        profilePic.value = data['profile_pic'] ?? "";

        log("User Data: Name: ${userName.value}, Email: ${userEmail.value}");
      } else {
        log("User document does not exist.");
      }
    } catch (e) {
      log("Error fetching user data: $e");
    }
  }
}
