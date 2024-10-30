import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:zoomer/presentations/screens/history/cancelled.dart';
import 'package:zoomer/presentations/screens/history/completed.dart';
import 'package:zoomer/presentations/screens/history/upcoming.dart';
import 'package:zoomer/presentations/screens/styles/appstyles.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("History"),
        ),
        body: Column(
          children: [
            ButtonsTabBar(
              backgroundColor: ThemeColors.primaryColor,
              borderWidth: 1,
              borderColor: Colors.black,
              labelStyle: const TextStyle(
                color: Colors.white,
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
    );
  }
}
