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
import 'package:zoomer/views/screens/bottom_screens/notification.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_drawer.dart';
import 'package:zoomer/views/screens/history/history_screen.dart';
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
  int _currentIndex = 0; // Track the currently selected tab index
  final AuthServices auth = AuthServices();
  final UserService userService = UserService();
  String? userEmail;
  String? userName;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Google Sign-In instance
  GoogleSignInAccount? _googleUser; // Google User instance
  XFile? _profileImage;
  // Pages for the Bottom Navigation Bar
  final List<Widget> _pages = [
    const HomeScreen(), // Home Page
    const HistoryScreen(), // History Page
  ];

  // GlobalKey for controlling the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _loadUserDetails();
    _fetchGoogleUser();
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
      });
    }
  } // Fetch Google Account Information

  Future<void> _fetchGoogleUser() async {
    try {
      GoogleSignInAccount? user = await _googleSignIn.signInSilently();
      if (user != null) {
        setState(() {
          _googleUser = user; // Update the state with Google user
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
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      drawer: const CustomDrawerawer(
        userEmail: '',
        userName: '',
        photoUrl: null,
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: GNav(
        rippleColor: Colors.grey[300]!,
        color: Theme.of(context).brightness == Brightness.dark
            ? ThemeColors.titleColor // Use titleColor in dark mode
            : ThemeColors.textColor, // Use textColor in light mode

        activeColor: Theme.of(context).brightness == Brightness.dark
            ? ThemeColors.textColor // Use textColor in dark mode
            : ThemeColors.titleColor, // Use titleColor in light mode

        gap: 8,
        tabMargin: const EdgeInsets.all(0),
        tabBorderRadius: 59,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        tabBackgroundColor: ThemeColors.primaryColor.withOpacity(0.1),
        tabs: const [
          GButton(
            icon: Icons.person,
            iconSize: 30,
            text: 'Profile',
          ),
          GButton(
            icon: Icons.home,
            iconSize: 30,
            text: 'Home',
          ),
          GButton(
            icon: Icons.history,
            iconSize: 30,
            text: 'Ride History',
          ),
        ],
        selectedIndex: _currentIndex,
        onTabChange: (index) {
          setState(() {
            if (index == 0) {
              // Profile icon - open drawer
              _scaffoldKey.currentState?.openDrawer();
            } else if (index == 1) {
              // Home icon - show home screen
              _currentIndex = 0;
            } else if (index == 2) {
              // Changed from index == 3 to index == 2
              // History icon - show history screen
              _currentIndex =
                  1; // Changed from 2 to 1 since we have only 2 pages
            }
          });
        },
      ),
    );
  }
}
