import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:zoomer/controllers/auth_services.dart';
import 'package:zoomer/screens/bottom_screens/notifications.dart';
import 'package:zoomer/screens/bottom_screens/rental_screen.dart';
import 'package:zoomer/screens/login_screens/sign_in_screen.dart';
import 'package:zoomer/styles/appstyles.dart';
import 'package:zoomer/screens/bottom_screens/home_screen.dart'; // Make sure to import your HomePage

class HomePage extends StatefulWidget {
  final String? email;
  final String? phoneNumber;
  const HomePage({super.key, this.email, this.phoneNumber});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Track the currently selected index
  final AuthServices auth = AuthServices();

  // GlobalKey for controlling the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const HomeScreen(), // Home Page
    const RentalScreen(), // Rentals Page
    const NotificationsScreen(), // Notifications Pag
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
              UserAccountsDrawerHeader(
                decoration:
                    const BoxDecoration(color: ThemeColors.primaryColor),
                accountName: Padding(
                  padding: const EdgeInsets.only(top: 17.0),
                  child: Text(widget.phoneNumber ?? ""),
                ),
                accountEmail: Text(widget.email ?? ""),
                currentAccountPicture: const CircleAvatar(
                  radius: 33,
                  backgroundImage:
                      AssetImage('assets/person.png'), // Default image
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Edit Profile"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("History"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Theme"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.warning_amber_outlined),
                title: const Text("Complain"),
                onTap: () {},
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
                  await auth.signout(); // Call the signout method
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
