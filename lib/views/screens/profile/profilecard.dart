import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class ProfileCard extends StatelessWidget {
  final String documentId;

  const ProfileCard({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: ThemeColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              // Dark theme: light background color
                              : Colors.white,
                      backgroundImage: const AssetImage(
                          'assets/images/single-person.png'), // Default image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ThemeColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Add logic to update the profile picture
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Input Fields
              _buildInputField(
                label: "Full Name",
                hintText: "Enter your name",
                controller: nameController,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Phone Number",
                hintText: "Enter your phone number",
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),
              _buildInputField(
                label: "City",
                hintText: "Enter your city",
                controller: cityController,
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: CustomButtons(
                  onPressed: () {
                    // Logic to save the profile details
                  },
                  text: "Save Changes",
                  backgroundColor: ThemeColors.primaryColor,
                  textColor: ThemeColors.textColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build input fields
  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
