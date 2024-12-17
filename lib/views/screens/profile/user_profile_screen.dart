import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize variables with widget data
    userName = widget.initialName ?? "Unnamed User";
    userEmail = widget.email!; // Now userEmail can accept null
    userPhotoUrl = widget.photoUrl;
    // If the userName is empty, prompt the user to enter their name
    if (userName == "Unnamed User") {
      _promptForName();
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

  // Pick profile image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
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
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
              // Future feature: Navigate to an edit profile screen
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
                      backgroundColor: Colors.white,
                      backgroundImage: _profileImage != null
                          ? FileImage(File(_profileImage!.path))
                          : const AssetImage('assets/images/single-person.png')
                              as ImageProvider,
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
