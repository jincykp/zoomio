import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String userName = "John Doe"; // Example data (replace with dynamic data)
  String userEmail =
      "john.doe@example.com"; // Example data (replace with dynamic data)
  String userPhone =
      "+1 234 567 890"; // Example data (replace with dynamic data)
  String userAddress =
      "123 Main Street, Cityville"; // Example data (replace with dynamic data)
  XFile? _profileImage; // To store the selected profile image

  final TextEditingController addressController = TextEditingController();

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
                  userAddress = addressController.text;
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
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile screen
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
                      // backgroundImage: _profileImage != null
                      //     ? FileImage(
                      //         _profileImage!.path,
                      //       )
                      //     : const AssetImage(
                      //         'assets/images/single-person.png',
                      //       ) as ImageProvider,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                  IconButton(
                    icon: const Icon(Icons.qr_code, color: Colors.white),
                    onPressed: () {
                      // QR code functionality
                    },
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
                    onTap: () {
                      // Optionally, add functionality to update phone number
                    },
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
                    onTap: _updateAddress, // Open dialog to update address
                  ),
                  const Divider(),
                  _buildProfileItem(
                    icon: Icons.payment,
                    title: "Payment Methods",
                    value: "Visa **** 1234",
                    onTap: () {
                      // Navigate to payment methods
                    },
                  ),
                  const Divider(),
                  _buildProfileItem(
                    icon: Icons.history,
                    title: "Ride History",
                    value: "View your rides",
                    onTap: () {
                      // Navigate to ride history
                    },
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
