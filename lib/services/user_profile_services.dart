// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:zoomer/views/screens/profile/profile_screen.dart';

// class UserProfileService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> saveUserProfile(UserProfile userProfile) async {
//     try {
//       // Save user profile to the "user_profiles" collection
//       await _firestore
//           .collection('user_profiles')
//           .doc(userProfile.id)
//           .set(userProfile.toJson());
//       print("User profile saved successfully!");
//     } catch (e) {
//       print("Failed to save user profile: $e");
//     }
//   }
// }
