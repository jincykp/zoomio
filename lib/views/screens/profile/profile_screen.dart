import 'package:flutter/material.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //  title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: ThemeColors.primaryColor, // Apply custom primary color
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
              color: ThemeColors.primaryColor, // Apply custom primary color
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                        'assets/default_user.png'), // Default user image
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "John Doe",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "+1 234 567 890",
                          style: TextStyle(
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
                    icon: Icons.email,
                    title: "Email",
                    value: "john.doe@example.com",
                  ),
                  const Divider(),
                  _buildProfileItem(
                    icon: Icons.location_on,
                    title: "Address",
                    value: "123 Main Street, Cityville",
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
      leading: Icon(icon,
          color: ThemeColors.primaryColor), // Use custom color for icons
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
