import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user details to Firestore
  Future<void> saveUserDetails(
      String uid, String email, String displayName) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'displayName': displayName,
    });
  }

  // Retrieve user details from Firestore
  Future<DocumentSnapshot> getUserDetails(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  } // Update user details with new data

  Future<void> updateUserDetails(
      String uid, Map<String, dynamic> newDetails) async {
    try {
      // Remove any null or empty values to prevent overwriting with invalid data
      newDetails.removeWhere((key, value) => value == null || value == "");

      if (newDetails.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(newDetails);
        print('User details updated successfully.');
      } else {
        print('No valid data to update.');
      }
    } catch (e) {
      print('Error updating user details: $e');
      rethrow; // Rethrow for higher-level handling
    }
  }
}
