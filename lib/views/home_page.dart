import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zoomer/controllers/theme.dart';
import 'package:zoomer/services/auth_services.dart';
import 'package:zoomer/services/userservices.dart';
import 'package:zoomer/views/screens/bottom_screens/home_screen.dart';
import 'package:zoomer/views/screens/bottom_screens/notification.dart';
import 'package:zoomer/views/screens/bottom_screens/rental.dart';
import 'package:zoomer/views/screens/complaints/complaints.dart';
import 'package:zoomer/views/screens/history/history.dart';
import 'package:zoomer/views/screens/login_screens/sign_in.dart';
import 'package:zoomer/views/screens/profile/profile_adding_screen.dart';
import 'package:zoomer/views/screens/profile/profile_screen.dart';
import 'package:zoomer/views/screens/profile/profilecard.dart';
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

  // Pages for the Bottom Navigation Bar
  final List<Widget> _pages = [
    const HomeScreen(), // Home Page
    const NotificationsScreen(), // Notifications Page
    const HistoryScreen(), // History Page
  ];

  // GlobalKey for controlling the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _loadUserDetails();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      endDrawer: _buildDrawer(context),
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
          GButton(icon: Icons.home),
          GButton(icon: Icons.notifications_active),
          GButton(icon: Icons.history),
        ],
        selectedIndex: _currentIndex,
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // Drawer for navigation
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
              icon: Icons.person,
              title: "Edit Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileCard(
                      documentId: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            _buildDrawerListTile(
              icon: Icons.dark_mode,
              title: "Theme",
              onTap: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
            const Divider(),
            _buildDrawerListTile(
              icon: Icons.warning_amber_outlined,
              title: "Complain",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ComplaintScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            _buildDrawerListTile(
              icon: Icons.info_outline,
              title: "About us",
              onTap: () {},
            ),
            const Divider(),
            _buildDrawerListTile(
              icon: Icons.settings,
              title: "Settings",
              onTap: () {},
            ),
            const Divider(),
            _buildDrawerListTile(
              icon: Icons.help_center_outlined,
              title: "Help and Support",
              onTap: () {},
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

  // User Header for the Drawer
  Widget _buildUserHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserProfile(),
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
          backgroundImage: const AssetImage(
            'assets/images/single-person.png',
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black // Dark theme: light background color
              : Colors.white, // Light theme: dark background color
        ),
      ),
    );
  }

  // Drawer List Tile Widget
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

  // Logout Handler
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
}
