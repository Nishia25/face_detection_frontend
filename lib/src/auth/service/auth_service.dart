import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Auth Error: ${e.message}");
      return Future.error(e.message ?? "An unknown error occurred");
    } catch (e) {
      log("Unexpected Error: $e");
      return Future.error("An unexpected error occurred");
    }
  }

  // Sign in
  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await saveUserSession(userCredential.user);
      return userCredential.user;
    } catch (e) {
      log("Unexpected Error: $e");
      return Future.error("An unexpected error occurred");
    }
  }

  Future<void> saveUserSession(User? user) async {
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.uid);
    }
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_id');
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Password reset
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

  // Auth state listener
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
