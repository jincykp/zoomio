import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomer/views/screens/history/bloc/ride_history_bloc.dart';
import 'package:zoomer/views/screens/history/cancelled_rides.dart';
import 'package:zoomer/views/screens/history/completed_rides.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RideHistoryBloc()..add(LoadRideHistory()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
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
                    tabs: const [
                      Tab(text: "Completed"),
                      Tab(text: "Cancelled"),
                    ],
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [CompletedTab(), CancelledTab()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
