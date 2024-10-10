import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoomer/views/styles/appstyles.dart';

class ProfileCard extends StatelessWidget {
  final String documentId; // Document ID for the specific profile

  const ProfileCard({super.key, required this.documentId});

  // Fetch the profile data from Firestore
  Future<Map<String, dynamic>> _getProfileData() async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(documentId) // Query using the document ID
        .get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      throw Exception('Profile not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getProfileData(), // Fetch the profile data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display loading indicator while waiting for data
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle errors
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // If data is available, display the profile
              final profileData = snapshot.data!;
              return Center(
                child: SizedBox(
                  height: 500,
                  width: 300,
                  child: Card(
                    color: ThemeColors.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: ThemeColors.textColor,
                                radius: 70,
                                backgroundImage: profileData['imageUrl'] != null
                                    ? NetworkImage(profileData['imageUrl'])
                                    : const AssetImage(
                                            'assets/images/default_profile.png')
                                        as ImageProvider, // Default image if no URL
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      // Add functionality if needed to change image
                                    },
                                    icon: const Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 22,
                                      color: ThemeColors.titleColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Name: ${profileData['name']}",
                            style: GoogleFonts.inconsolata(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Text(
                            "Street: ${profileData['street']}",
                            style: GoogleFonts.inconsolata(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Text(
                            "City: ${profileData['city']}",
                            style: GoogleFonts.inconsolata(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Text(
                            "District: ${profileData['district']}",
                            style: GoogleFonts.inconsolata(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              // If no data is available, show this message
              return const Center(child: Text('No profile data found'));
            }
          },
        ),
      ),
    );
  }
}
