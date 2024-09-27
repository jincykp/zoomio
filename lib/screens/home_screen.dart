import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:zoomer/controllers/auth_services.dart';
import 'package:zoomer/screens/bottom_screens/notifications.dart';
import 'package:zoomer/screens/bottom_screens/rental_screen.dart';
import 'package:zoomer/screens/login_screens/sign_in_screen.dart';
import 'package:zoomer/screens/otp_verification/profile_creation.dart';
import 'package:zoomer/styles/appstyles.dart';
import 'package:zoomer/screens/bottom_screens/home_page.dart'; // Make sure to import your HomePage

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Track the currently selected index
  final AuthServices auth = AuthServices();
  final List<Widget> _pages = [
    const HomePage(), // Home Page
    const RentalScreen(), // Rentals Page
    const NotificationsScreen(), // Notifications Page
    const ProfileCreationScreen(), // Profile Creation Page
  ]; // List of pages corresponding to each icon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: const [],
      ),
      body: _pages[
          _currentIndex], // Display the selected page based on the current index
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.home, color: ThemeColors.primaryColor),
          Icon(Icons.car_rental, color: ThemeColors.primaryColor),
          Icon(Icons.notifications_active, color: ThemeColors.primaryColor),
          Icon(Icons.person, color: ThemeColors.primaryColor), // Profile icon
        ],
        backgroundColor: ThemeColors.primaryColor,
        color: ThemeColors.titleColor,
        onTap: (index) {
          setState(() {
            _currentIndex =
                index; // Update the current index when an icon is tapped
          });
        },
      ),
      endDrawer: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50.0),
          bottomLeft: Radius.circular(50.0),
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero, // This removes any default padding.
            children: [
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: ThemeColors.primaryColor),
                accountName: Padding(
                  padding: EdgeInsets.only(top: 17.0),
                  child: Text("Jincy"),
                ),
                accountEmail: Text("ljal@hmail.com"),
                currentAccountPicture: CircleAvatar(
                  radius: 33,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                ),
                title: const Text(
                  "Edit Profile",
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.history,
                ),
                title: const Text(
                  "History",
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.dark_mode,
                ),
                title: const Text(
                  "Theme",
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.warning_amber_outlined,
                ),
                title: const Text(
                  "Complain",
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                ),
                title: const Text(
                  "About us",
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                ),
                title: const Text(
                  "Settings",
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.help_center_outlined,
                ),
                title: const Text(
                  "Help and Support",
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                ),
                title: const Text(
                  "Logout",
                ),
                onTap: () async {
                  await auth.signout(); // Call the signout method
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
