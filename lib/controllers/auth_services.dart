import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoomer/screens/home_page.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<String?> getUserPhoneNumber(String email) async {
    try {
      // Query the Firestore collection where user data is stored
      QuerySnapshot snapshot = await _firestore
          .collection(
              'users') // Adjust the collection name as per your Firestore structure
          .where('email', isEqualTo: email) // Find user by email
          .get();

      if (snapshot.docs.isNotEmpty) {
        // If user exists, get the phone number from the first document
        DocumentSnapshot userDoc = snapshot.docs.first;
        return userDoc[
            'phoneNumber']; // Adjust the field name as per your Firestore structure
      }
    } catch (e) {
      log("Error fetching phone number: $e");
      return null; // Handle error and return null if fetching fails
    }
    return null; // Return null if user not found
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

        // Get user email
        String email = googleUser.email;

        // Fetch phone number from the database using the user's email
        String? phoneNumber =
            await getUserPhoneNumber(email); // Corrected method call

        // Navigate to HomePage and pass the email and phone number
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              email: email,
              phoneNumber: phoneNumber ??
                  'Phone number not found', // Handle case where phone number is not found
            ),
          ),
        );
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
}
