import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:zoomer/views/screens/history/cancelled.dart';
import 'package:zoomer/views/screens/history/completed.dart';
import 'package:zoomer/views/screens/history/upcoming.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ButtonsTabBar(
                backgroundColor: ThemeColors.primaryColor,
                borderWidth: 1,
                borderColor: Colors.black,
                labelStyle: const TextStyle(
                  color: ThemeColors.titleColor,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                // The tabs
                tabs: const [
                  Tab(text: "Upcoming"),
                  Tab(text: "Completed"),
                  Tab(text: "Cancelled"),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [UpcomingTab(), CompletedTab(), CancelledTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}