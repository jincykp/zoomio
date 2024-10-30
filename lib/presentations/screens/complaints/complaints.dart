import 'package:flutter/material.dart';
import 'package:zoomer/presentations/screens/custom_widgets/custom_buttons.dart';
import 'package:zoomer/presentations/screens/styles/appstyles.dart';

class ComplaintScreen extends StatelessWidget {
  const ComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaint"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down)),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 140,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            CustomButtons(
                text: "Submit",
                onPressed: () {},
                backgroundColor: ThemeColors.primaryColor,
                textColor: ThemeColors.textColor,
                screenWidth: screenWidth * 0.02,
                screenHeight: screenHeight * 0.02)
          ],
        ),
      ),
    );
  }
}
