import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user details to Firestore
  Future<void> saveUserDetails(
      String uid, String email, String displayName) async {
    try {
      // Check if user document already exists
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        // Create new user document with auth UID
        await _firestore.collection('users').doc(uid).set({
          'email': email,
          'displayName': displayName,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing document
        await _firestore.collection('users').doc(uid).update({
          'email': email,
          'displayName': displayName,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      log("Error saving user details: $e");
      throw Exception('Failed to save user details: $e');
    }
  }

  // Retrieve user details from Firestore
  Future<DocumentSnapshot> getUserDetails(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      log("Error getting user details: $e");
      throw Exception('Failed to get user details: $e');
    }
  }

  Future<void> updateUserDetails(
      String uid, Map<String, dynamic> newDetails) async {
    try {
      newDetails.removeWhere((key, value) => value == null || value == "");

      if (newDetails.isNotEmpty) {
        newDetails['lastUpdated'] = FieldValue.serverTimestamp();
        await _firestore.collection('users').doc(uid).update(newDetails);
        log('User details updated successfully.');
      } else {
        log('No valid data to update.');
      }
    } catch (e) {
      log('Error updating user details: $e');
      rethrow;
    }
  }
}
