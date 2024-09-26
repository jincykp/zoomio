import 'package:flutter/material.dart';
import 'package:zoomer/screens/login_screens/mapenable_screen.dart';
import 'package:zoomer/styles/appstyles.dart';

class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight *
                          0.4, // Adjust image height based on available space
                      child: Image.asset(
                        "assets/Frame 1.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05), // Spacing
                    Text(
                      'Book Your Ride',
                      style: Textstyles.titleText.copyWith(
                        fontSize: screenWidth * 0.05,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02), // Spacing
                    Text(
                      'Choose your ride with just a few taps. Enjoy a smooth and personalized booking experience tailored to you!',
                      style: Textstyles.bodytext.copyWith(
                        fontSize: screenWidth * 0.04,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.1), // Spacing
                    Container(
                      decoration: const BoxDecoration(
                        color: ThemeColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapenableScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Go",
                          style: TextStyle(
                            color: ThemeColors.titleColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
