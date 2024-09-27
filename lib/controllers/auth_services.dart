import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoomer/screens/home_screen.dart';

class AuthServices {
  final GoogleSignIn googleSignIn = GoogleSignIn(); // Initialized GoogleSignIn
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Create account with email and password
  Future<User?> createAccountWithEmail(String email, String password) async {
    try {
      final cred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
  }

  // Login with email and password
  Future<User?> loginAccountWithEmail(String email, String password) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
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
        await auth.signInWithCredential(credential);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      log("Google Sign-In failed: $e");
    }
  }

  Future<void> sendEailVerificationLink() async {
    try {
      await auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }
}
