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
  }
}
