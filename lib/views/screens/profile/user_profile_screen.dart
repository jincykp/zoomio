import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoomer/services/image_storage_services.dart';
import 'package:zoomer/services/userservices.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class UserProfile extends StatefulWidget {
  final String? email;
  final String? initialName;
  final String? photoUrl;

  const UserProfile({
    Key? key,
    this.email,
    this.initialName,
    this.photoUrl,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String userName = ""; // Example data (replace with dynamic data)
  String userEmail = ""; // Example data
  String userPhone = ""; // Example data
  String userAddress = ""; // Example data
  XFile? _profileImage;
  String? userPhotoUrl; // To store the selected profile image
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final ImageStorageService _imageStorageService = ImageStorageService();
// Pick profile image and upload it to Firebase
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });

      // Upload the image and get the URL
      File imageFile = File(pickedFile.path);
      String fileName = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); // Use timestamp as unique file name

      String? downloadUrl =
          await _imageStorageService.uploadProfileImage(imageFile, fileName);

      if (downloadUrl != null) {
        setState(() {
          userPhotoUrl = downloadUrl; // Update the profile photo URL
        });

        // Optionally, update this URL in the Firestore database
        // For example: FirebaseFirestore.instance.collection('users').doc(userEmail).update({'photoUrl': downloadUrl});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize variables with widget data
    userName = widget.initialName ?? "Unnamed User";
    userEmail = widget.email ?? ""; // Handles potential null email
    userPhotoUrl = widget.photoUrl;
    _loadUserData(); // Always load data to ensure latest updates from Firestore

    // If the userName is empty, prompt the user to enter their name
    if (userName == "Unnamed User") {
      _promptForName();
    }
  }

// Fetch user data from Firebase
  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc.data().toString().contains('displayName')
                ? userDoc['displayName']
                : "Unnamed User";
            userEmail = userDoc.data().toString().contains('email')
                ? userDoc['email']
                : "";
            userPhone = userDoc.data().toString().contains('phone')
                ? userDoc['phone']
                : "";
            userAddress = userDoc.data().toString().contains('address')
                ? userDoc['address']
                : "";
            // Only update photoUrl if there's one in Firestore
            if (userDoc.data().toString().contains('photoUrl') &&
                userDoc['photoUrl'] != null) {
              userPhotoUrl = userDoc['photoUrl'];
            }
            // If no Firestore photo URL, keep the Google photo URL from widget.photoUrl
          });
        }
      } catch (e) {
        print("Error loading user data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading data. Please try again.")),
        );
      }
    }
  }

  // Show a dialog to prompt for the user's name initially
  void _promptForName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Your Name'),
          content: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  userName = nameController.text.isNotEmpty
                      ? nameController.text
                      : "Unnamed User";
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Method to update the user's profile on Firebase
  Future<void> _saveUserProfile() async {
    // Get the current user's UID
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user is currently logged in')),
      );
      return;
    }

    // Collect the updated user details
    Map<String, dynamic> updatedDetails = {
      'displayName': userName,
      'email': userEmail,
      'phone': userPhone,
      'address': userAddress,
      'photoUrl': userPhotoUrl,
    };

    try {
      // Use the current user's UID, not email
      await UserService().updateUserDetails(currentUser.uid, updatedDetails);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: ThemeColors.successColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Show a dialog to update the address
  void _updateAddress() {
    addressController.text = userAddress; // Pre-fill the text field
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Address'),
          content: TextFormField(
            controller: addressController,
            decoration: const InputDecoration(
              hintText: 'Enter your address',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  userAddress = addressController.text.isNotEmpty
                      ? addressController.text
                      : userAddress;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(
                    color: ThemeColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: ThemeColors.baseColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show a dialog to update the name
  void _updateName() {
    nameController.text = userName; // Pre-fill the text field
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Name'),
          content: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  userName = nameController.text.isNotEmpty
                      ? nameController.text
                      : "unnamed User";
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save',
                  style: TextStyle(
                      color: ThemeColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: ThemeColors.baseColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show a dialog to update the phone number
  void _updatePhoneNumber() {
    phoneController.text = userPhone; // Pre-fill the text field
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Phone Number'),
          content: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Enter your phone number',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  userPhone = phoneController.text.isNotEmpty
                      ? phoneController.text
                      : userPhone;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(
                    color: ThemeColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: TextStyle(
                      color: ThemeColors.baseColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ThemeColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveUserProfile();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              color: ThemeColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage, // Pick a new profile picture when tapped
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: ThemeColors.primaryColor,
                      // Only set backgroundImage if we have a photo, otherwise it blocks the child Text
                      backgroundImage: _profileImage != null
                          ? FileImage(File(_profileImage!.path))
                          : (userPhotoUrl != null
                              ? NetworkImage(userPhotoUrl!)
                              : null) as ImageProvider?,
                      // Display first letter of email when no image is available
                      child: (userPhotoUrl == null && _profileImage == null)
                          ? Text(
                              userEmail.isNotEmpty
                                  ? userEmail[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _updateName,
                          child: Text(
                            userName.isNotEmpty ? userName : "Name",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Info Section
            Expanded(
              child: ListView(
                children: [
                  _buildProfileItem(
                    icon: Icons.phone,
                    title: "Phone Number",
                    value: userPhone,
                    onTap: _updatePhoneNumber,
                  ),
                  const Divider(),
                  _buildProfileItem(
                    icon: Icons.email,
                    title: "Email",
                    value: userEmail,
                  ),
                  const Divider(),
                  _buildProfileItem(
                    icon: Icons.location_on,
                    title: "Address",
                    value: userAddress,
                    onTap: _updateAddress,
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Profile Details
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: ThemeColors.primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing:
          onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
    );
  }
}
