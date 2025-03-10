import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zoomer/services/auth_services.dart';
import 'package:zoomer/services/userservices.dart';
import 'package:zoomer/views/screens/bottom_screens/home_screen.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_drawer.dart';
import 'package:zoomer/views/screens/history/history_screen.dart';
import 'package:zoomer/views/screens/profile/user_profile_screen.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  final String? email;
  final String? displayName;
  const HomePage({super.key, this.email, this.displayName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variables
  int _selectedIndex = 1; // Default to home tab (index 1)
  final AuthServices auth = AuthServices();
  final UserService userService = UserService();
  String? userEmail;
  String? userName;
  String? userPhotoUrl;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleUser;
  XFile? _profileImage;

  // GlobalKey for controlling the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Pages list declaration at class level
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _loadUserDetails();
    _fetchGoogleUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize pages here after user data is loaded
    _initializePages();
  }

  // Initialize pages with current user data
  void _initializePages() {
    _pages = [
      UserProfile(
        email: userEmail,
        initialName: userName,
        photoUrl: _googleUser?.photoUrl ?? userPhotoUrl,
      ),
      const HomeScreen(),
      const HistoryScreen(),
    ];
  }

  // Request location permission
  void _requestLocationPermission() {
    Permission.locationWhenInUse.isDenied.then((isDenied) {
      if (isDenied) {
        Permission.locationWhenInUse.request();
      }
    });
  }

  // Load user details
  Future<void> _loadUserDetails() async {
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await userService.getUserDetails(user.uid);
      setState(() {
        userEmail = userDoc['email'];
        userName = userDoc['displayName'];
        // Get photo URL if available
        if (userDoc.data().toString().contains('photoUrl')) {
          userPhotoUrl = userDoc['photoUrl'];
        }
        // Re-initialize pages with updated user data
        _initializePages();
      });
    }
  }

  // Fetch Google Account Information
  Future<void> _fetchGoogleUser() async {
    try {
      GoogleSignInAccount? user = await _googleSignIn.signInSilently();
      if (user != null) {
        setState(() {
          _googleUser = user;
          // Re-initialize pages with updated Google user data
          _initializePages();
        });
      }
    } catch (e) {
      print("Error fetching Google user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _pages[_selectedIndex], // Show the selected page based on index
      bottomNavigationBar: Container(
        color: ThemeColors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
          child: GNav(
            backgroundColor: ThemeColors.primaryColor,
            color: Theme.of(context).brightness == Brightness.light
                ? ThemeColors.textColor
                : Colors.black,
            activeColor: ThemeColors.primaryColor,
            iconSize: 24,
            tabBackgroundColor: Theme.of(context).brightness == Brightness.light
                ? ThemeColors.textColor
                : Colors.black,
            padding: const EdgeInsets.all(10),
            selectedIndex: _selectedIndex, // Set the current selected tab
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index; // Simply update the selected index
              });
            },
            tabs: const [
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.history,
                text: 'Ride History',
              ),
            ],
          ),
        ),
      ),
      // Keep the drawer for access from other parts of the app
      drawer: CustomDrawerawer(
        userEmail: userEmail ?? '',
        userName: userName ?? '',
        photoUrl: _googleUser?.photoUrl ?? userPhotoUrl,
      ),
    );
  }
}
