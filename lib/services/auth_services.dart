import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoomer/services/userservices.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/login_screens/profile_creation.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(); // Initialized GoogleSignIn
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UserService userService = UserService(); // User service instance

  // Create account with email and password
  Future<User?> createAccountWithEmail(
      String email, String password, String? displayName) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        // Immediately save user data to Firestore using the auth UID
        await userService.saveUserDetails(
          user.uid, // Using the Firebase Auth UID
          email,
          displayName ?? "",
        );

        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
      }

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

//emailverification
  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      throw Exception('Failed to send verification email: $e');
    }
  }

  Future<User?> loginAccountWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        throw Exception('Email is not verified. Please check your email.');
      }

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Sign out
  Future<void> signout() async {
    try {
      await auth.signOut();
      await googleSignIn.signOut(); // Sign out from Google
    } catch (e) {
      log("Error during signout: $e");
    }
  }

  // Reset password
  Future<String> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return "Mail sent";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // Google Sign-in

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credentials
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Save user details to Firestore using the auth UID
          await userService.saveUserDetails(
            user.uid, // Using the Firebase Auth UID
            googleUser.email,
            googleUser.displayName ?? "",
          );

          // Navigate to HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                email: googleUser.email,
                displayName: googleUser.displayName,
              ),
            ),
          );
        }
      }
    } catch (e) {
      log("Google Sign-In failed: $e");
    }
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      await auth.currentUser?.sendEmailVerification();
    } catch (e) {
      log(e.toString());
    }
  }

// Getter to retrieve the currently signed-in user
  User? get currentUser {
    return auth.currentUser;
  }
}
