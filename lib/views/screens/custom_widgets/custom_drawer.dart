import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; // Required for ThemeCubit (ensure you have this)
import 'package:zoomer/controllers/theme.dart';
import 'package:zoomer/services/auth_services.dart';
import 'package:zoomer/services/userservices.dart';
import 'package:zoomer/views/screens/complaints/complaints.dart';
import 'package:zoomer/views/screens/drawer_screens/about_us.dart';
import 'package:zoomer/views/screens/drawer_screens/help_and_support.dart';
import 'package:zoomer/views/screens/drawer_screens/privacy_ppolicy.dart';
import 'package:zoomer/views/screens/login_screens/sign_in.dart';
import 'package:zoomer/views/screens/profile/user_profile_screen.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class CustomDrawerawer extends StatefulWidget {
  final String? userEmail;
  final String? userName;
  final dynamic photoUrl;

  const CustomDrawerawer({
    super.key,
    required this.userEmail,
    required this.userName,
    required this.photoUrl,
  });

  @override
  State<CustomDrawerawer> createState() => _CustomDrawerawerState();
}

class _CustomDrawerawerState extends State<CustomDrawerawer> {
  final AuthServices auth = AuthServices();
  final UserService userService = UserService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? userEmail;
  String? userName;
  GoogleSignInAccount? _googleUser;
  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _fetchGoogleUser();
  }

  Future<void> _loadUserDetails() async {
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await userService.getUserDetails(user.uid);
      setState(() {
        userEmail = userDoc['email'];
        userName = userDoc['displayName'];
      });
    }
  }

  Future<void> _fetchGoogleUser() async {
    try {
      GoogleSignInAccount? user = await _googleSignIn.signInSilently();
      if (user != null) {
        setState(() {
          _googleUser = user;
        });
      }
    } catch (e) {
      print("Error fetching Google user: $e");
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Logout Confirmation",
            style: Textstyles.gTextdescription,
          ),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await auth.signout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfile(
              email: userEmail,
              initialName: userName,
              photoUrl: _googleUser?.photoUrl,
            ),
          ),
        );
      },
      child: UserAccountsDrawerHeader(
        decoration: const BoxDecoration(color: ThemeColors.primaryColor),
        accountName: userName != null && userName!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Text(userName!),
              )
            : null,
        accountEmail: Text(userEmail ?? ""),
        currentAccountPicture: CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          backgroundImage: _profileImage != null
              ? FileImage(File(_profileImage!.path))
              : (_googleUser?.photoUrl != null
                  ? NetworkImage(_googleUser!.photoUrl!)
                  : const AssetImage('assets/images/single-person.png')
                      as ImageProvider),
        ),
      ),
    );
  }

  Widget _buildDrawerListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        bottomLeft: Radius.circular(0),
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildUserHeader(context),
            _buildDrawerListTile(
              icon: Icons.dark_mode,
              title: "Theme",
              onTap: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
            const Divider(),
            _buildDrawerListTile(
              icon: Icons.settings,
              title: "Settings",
              onTap: () {},
            ),
            const Divider(),
            _buildDrawerListTile(
              icon: Icons.info_outline,
              title: "About us",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUsScreen()));
              },
            ),
            const Divider(),
            _buildDrawerListTile(
              icon: Icons.privacy_tip,
              title: "Privacy Policy",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen()));
              },
            ),
            const Divider(),
            _buildDrawerListTile(
              icon: Icons.help_center_outlined,
              title: "Help and Support",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpAndSupportScreen()));
              },
            ),
            const Divider(),
            _buildDrawerListTile(
              icon: Icons.logout,
              title: "Logout",
              onTap: () async => _handleLogout(context),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDrawer(context);
  }
}
