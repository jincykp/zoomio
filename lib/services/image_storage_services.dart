import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class ImageStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> uploadProfileImage(File imageFile, String fileName) async {
    try {
      // Reference the folder and file within it
      Reference ref = FirebaseStorage.instance.ref().child('license/$fileName');

      // Upload the image file
      UploadTask uploadTask = ref.putFile(imageFile);

      // Wait for upload completion
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      // Get the download URL of the uploaded image
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      print('Image uploaded successfully: $downloadUrl');
      return downloadUrl; // Return the download URL
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Return null if there's an error
    }
  }
}
