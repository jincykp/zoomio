import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int _currentIndex = 0; // Track the currently selected index
  final AuthServices auth = AuthServices();
  final UserService userService = UserService();
  String? userEmail;
  String? userName;
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
      if (valueOfPermission) {
        Permission.locationWhenInUse.request();
      }
    });
    loadUserDetails();
  }

  // GlobalKey for controlling the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const HomeScreen(), // Home Page
    //const RentalScreen(), // Rentals Page
    const NotificationsScreen(),
    const HistoryScreen(),
  ];
  Future<void> loadUserDetails() async {
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await userService.getUserDetails(user.uid);
      setState(() {
        userEmail = userDoc['email'];
        userName = userDoc['displayName'];
      });
    } else {
      // Handle the case when no user is signed in (if needed)
    }
  } // Method to load the map style based on the current theme

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //  appBar: AppBar(),
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
          color: ThemeColors.titleColor,
          gap: 8,
          activeColor: ThemeColors.textColor,
          tabMargin: const EdgeInsets.all(0),
          tabBorderRadius: 59,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          // duration: const Duration(milliseconds: 300),
          tabBackgroundColor: ThemeColors.primaryColor.withOpacity(0.1),
          tabs: const [
            GButton(
              icon: Icons.home,
              // text: 'Home',
            ),
            GButton(
              icon: Icons.notifications_active,
              // text: 'Notifications',
            ),
            GButton(
              icon: Icons.history,
              // text: 'History',
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
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
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
                  accountName: userName != null && userName!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 17.0),
                          child:
                              Text(userName!), // Display user name if available
                        )
                      : null, // If userName is null or empty, do not display anything
                  accountEmail: Text(userEmail ?? ""), // Display email
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
              const Divider(),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Theme"),
                onTap: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
              const Divider(),
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
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("About us"),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_center_outlined),
                title: const Text("Help and Support"),
                onTap: () {},
              ),
              const Divider(),
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
                          style: Textstyles.gTextdescription,
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
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
