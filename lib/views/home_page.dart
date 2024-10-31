import 'package:flutter/material.dart';
import 'package:zoomer/controllers/authservices.dart';
import 'package:zoomer/views/screens/bottom_screens/all_trips.dart';
import 'package:zoomer/views/screens/bottom_screens/home_screen.dart';
import 'package:zoomer/views/screens/bottom_screens/notification.dart';
import 'package:zoomer/views/screens/bottom_screens/rental.dart';
import 'package:zoomer/views/screens/complaints/complaints.dart';
import 'package:zoomer/views/screens/history/history.dart';
import 'package:zoomer/views/screens/login_screens/sign_in.dart';
import 'package:zoomer/views/screens/profile/profile_adding_screen.dart';
import 'package:zoomer/views/screens/profile/profilecard.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';
import 'package:google_nav_bar/google_nav_bar.dart'; // Import GoogleNavBar

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

  final List<Widget> _pages = [
    const HomeScreen(), // Home Page
    const RentalScreen(), // Rentals Page
    const NotificationsScreen(),
    const AllTrips(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
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
          // color: ThemeColors.primaryColor,
          gap: 8,
          //activeColor: ThemeColors.titleColor,
          tabMargin: const EdgeInsets.all(0),
          tabBorderRadius: 59,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          // duration: const Duration(milliseconds: 300),
          tabBackgroundColor: ThemeColors.primaryColor.withOpacity(0.1),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.car_rental,
              text: 'Rentals',
            ),
            GButton(
              icon: Icons.notifications_active,
              text: 'Notifications',
            ),
            GButton(
              icon: Icons.history,
              text: 'History',
            ),
          ],
          selectedIndex: _currentIndex,
          onTabChange: (intex) {
            setState(() {
              _currentIndex = intex;
            });
          },
        ),
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
                    backgroundImage: AssetImage(
                        'assets/images/person.jpeg'), // Default image
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
