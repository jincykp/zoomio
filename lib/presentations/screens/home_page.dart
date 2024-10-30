import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:zoomer/controllers/auth_services.dart';
import 'package:zoomer/presentations/screens/bottom_screens/home_screen.dart';
import 'package:zoomer/presentations/screens/bottom_screens/notifications.dart';
import 'package:zoomer/presentations/screens/bottom_screens/rental_screen.dart';
import 'package:zoomer/presentations/screens/complaints/complaints.dart';
import 'package:zoomer/presentations/screens/history/history.dart';
import 'package:zoomer/presentations/screens/login_screens/sign_in_screen.dart';
import 'package:zoomer/presentations/screens/otp_verification/profilecard.dart';
import 'package:zoomer/presentations/screens/profile/profile_adding_screen.dart';
import 'package:zoomer/presentations/screens/styles/appstyles.dart';

class HomePage extends StatefulWidget {
  final String? email;
  final String? displayName;
  const HomePage({super.key, this.email, this.displayName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Track the currently selected index
  final AuthServices auth = AuthServices();

  // GlobalKey for controlling the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Removed the image variable and image picking function
  // File? _image; // Variable to hold the picked image

  final List<Widget> _pages = [
    const HomeScreen(), // Home Page
    const RentalScreen(), // Rentals Page
    const NotificationsScreen(), // Notifications Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: _pages[_currentIndex],
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
            if (index == 3) {
              // If the profile icon is tapped, open the drawer instead of changing the page
              _scaffoldKey.currentState?.openEndDrawer();
            } else {
              _currentIndex = index; // Change the current page for other icons
            }
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ProfileCard(documentId: 'your_document_id'),
                    ),
                  );
                },
                child: UserAccountsDrawerHeader(
                  decoration:
                      const BoxDecoration(color: ThemeColors.primaryColor),
                  accountName: Padding(
                    padding: const EdgeInsets.only(top: 17.0),
                    child: Text(widget.displayName ?? ""),
                  ),
                  accountEmail: Text(widget.email ?? ""),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/person.png'), // Default image
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Edit Profile"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProfileDetails()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("History"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Theme"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.warning_amber_outlined),
                title: const Text("Complain"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ComplaintScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("About us"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help_center_outlined),
                title: const Text("Help and Support"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () async {
                  // Show a confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Logout Confirmation",
                          style: Textstyles.buttonText,
                        ),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await auth.signout();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInScreen()),
                              );
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
