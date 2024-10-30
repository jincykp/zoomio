import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  Future<void> addUserDetails(
      Map<String, dynamic> userDetails, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("user_details") // Ensure consistency in collection name
          .doc(id)
          .set(userDetails);
    } catch (e) {
      // Handle errors as needed
      throw e;
    }
  }

  //create user profile
  Future createUserProfile({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("user_details").add(data);
  }
  // edit user profile
  // Future updateUserProfile({required String.docId,required Map<String,dynamic>data})async{
  //   await FirebaseFirestore.instance.collection("user_profile").doc(docId).update(data);
  //   }
}
