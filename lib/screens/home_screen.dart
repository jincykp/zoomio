import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:zoomer/styles/appstyles.dart';
import 'package:fan_side_drawer/fan_side_drawer.dart';

import '../custom_widgets/menu_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Ensure this uses the correct type expected by FanSideDrawer
  List<FanMenuItem> get menuItems => [
        FanMenuItem(
          title: 'Home',
          icon: Icons.house_rounded,
          onTap: () {
            // Handle Home tap
          },
        ),
        FanMenuItem(
          title: 'Account Details',
          icon: Icons.account_circle_rounded,
          onTap: () {
            // Handle Account Details tap
          },
        ),
        // Add more menu items here
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: const [],
      ),
      body: const Center(
        child: Text("Home"),
      ),
      drawer: FanSideDrawer(
        drawerType: DrawerType.pipe,
        menuItems: menuItems, // Ensure this matches the expected type
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(
            Icons.home,
            color: ThemeColors.primaryColor,
          ),
          Icon(Icons.car_rental, color: ThemeColors.primaryColor),
          Icon(Icons.notifications_active, color: ThemeColors.primaryColor),
          Icon(
            Icons.person,
            color: ThemeColors.primaryColor,
          ),
        ],
        backgroundColor: ThemeColors.primaryColor,
        color: ThemeColors.titleColor,
        height: 60.0,
        onTap: (index) {
          // Handle the tap on the bottom navigation bar
        },
      ),
    );
  }
}
