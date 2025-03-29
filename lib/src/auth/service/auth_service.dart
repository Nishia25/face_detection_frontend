import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vision_intelligence/firebase/request_permission.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Sign up with Email & Password
  Future<User?> createUserWithEmailAndPassword(String email,
      String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Auth Error: ${e.message}");
      return Future.error(e.message ?? "An unknown error occurred");
    } catch (e) {
      log("Unexpected Error: $e");
      return Future.error("An unexpected error occurred");
    }
  }

  // 🔹 Sign in with Email & Password
  Future<User?> loginUserWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await updateFCMToken();
      await saveUserSession(userCredential.user);
      return userCredential.user;
    } catch (e) {
      log("Unexpected Error: $e");
      return Future.error("An unexpected error occurred");
    }
  }

  // 🔹 Save User Session (SharedPreferences)
  Future<void> saveUserSession(User? user) async {
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.uid);
    }
  }

  // 🔹 Check if User is Logged In
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_id');
  }

  // 🔹 Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // 🔹 Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      log("Password Reset Error: ${e.message}");
      return Future.error(e.message ?? "Failed to send reset email");
    } catch (e) {
      log("Unexpected Error: $e");
      return Future.error("An unexpected error occurred");
    }
  }
}
