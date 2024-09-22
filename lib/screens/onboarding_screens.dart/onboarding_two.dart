import 'package:flutter/material.dart';
import 'package:zoomer/screens/onboarding_screens.dart/onboarding_three.dart';
import 'package:zoomer/styles/appstyles.dart';

class OnboardingScreenTwo extends StatelessWidget {
  const OnboardingScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/At anytime.png",
                height: screenWidth * 0.5,
              ),
              Text(
                'At Any Time',
                style:
                    Textstyles.titleText.copyWith(fontSize: screenWidth * 0.05),
              ),
              Text(
                "Book your ride whenever you need it, day or night. We're always here to take you where you want to go!",
                style:
                    Textstyles.bodytext.copyWith(fontSize: screenWidth * 0.04),
                textAlign: TextAlign.center,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: ThemeColors.primaryColor, shape: BoxShape.circle),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const OnboardingScreenThree()));
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      color: ThemeColors.titleColor,
                      size: screenWidth * 0.07,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
