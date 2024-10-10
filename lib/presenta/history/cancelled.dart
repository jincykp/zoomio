import 'package:flutter/material.dart';

class CancelledTab extends StatelessWidget {
  const CancelledTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 7, // Example item count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Cancelled Item ${index + 1}",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}
