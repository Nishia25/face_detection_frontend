import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vision_intelligence/firebase/request_permission.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Sign up with Email & Password
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

  // 🔹 Sign in with Email & Password
  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
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

  // 🔹 Listen to Auth State Changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─────────────────────────────────────────────────────────────────
  // ✅ SOCIAL AUTHENTICATION METHODS
  // ─────────────────────────────────────────────────────────────────

  // 🔹 Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: "523746350716-gt9a14t6pcbsfbuhef6sr28g4pac7b06.apps.googleusercontent.com", // Add your Web Client ID here
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      log("Google Sign-In Error: $e");
      return Future.error("Google Sign-In failed");
    }
  }


  // 🔹 Facebook Sign-In
  // Future<User?> signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
  //       final userCredential = await _auth.signInWithCredential(credential);
  //       return userCredential.user;
  //     } else {
  //       return Future.error("Facebook Sign-In failed");
  //     }
  //   } catch (e) {
  //     log("Facebook Sign-In Error: $e");
  //     return Future.error("Facebook Sign-In failed");
  //   }
  // }

  // 🔹 Twitter Sign-In
  Future<User?> signInWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
        apiKey: "your_twitter_api_key",
        apiSecretKey: "your_twitter_api_secret",
        redirectURI: "your_app_redirect_uri",
      );

      final authResult = await twitterLogin.login();
      if (authResult.status == TwitterLoginStatus.loggedIn) {
        final credential = TwitterAuthProvider.credential(
          accessToken: authResult.authToken!,
          secret: authResult.authTokenSecret!,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      } else {
        return Future.error("Twitter Sign-In failed");
      }
    } catch (e) {
      log("Twitter Sign-In Error: $e");
      return Future.error("Twitter Sign-In failed");
    }
  }

  // 🔹 GitHub Sign-In
  Future<User?> signInWithGitHub() async {
    try {
      final String clientId = "your_github_client_id";
      final String redirectUri = "https://your-firebase-project.firebaseapp.com/__/auth/handler";

      final authUrl = "https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=read:user%20user:email";

      final result = await FlutterWebAuth.authenticate(
          url: authUrl,
          callbackUrlScheme: "https"
      );

      final code = Uri.parse(result).queryParameters["code"];

      final response = await http.post(
          Uri.parse("https://github.com/login/oauth/access_token"),
          headers: {"Accept": "application/json"},
          body: {
            "client_id": clientId,
            "client_secret": "your_github_client_secret",
            "code": code
          }
      );

      final accessToken = json.decode(response.body)["access_token"];
      final githubAuthCredential = GithubAuthProvider.credential(accessToken);

      final userCredential = await _auth.signInWithCredential(githubAuthCredential);
      return userCredential.user;
    } catch (e) {
      log("GitHub Sign-In Error: $e");
      return Future.error("GitHub Sign-In failed");
    }
  }
}
