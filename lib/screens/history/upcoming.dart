import 'package:flutter/material.dart';

class UpcomingTab extends StatelessWidget {
  const UpcomingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Example item count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Upcoming Item ${index + 1}",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}
