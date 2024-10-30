import 'package:flutter/material.dart';
import 'package:zoomer/presentations/screens/styles/appstyles.dart';

class OnBoardingInfo {
  final String title;
  final String description;
  final String image;
  final Widget? button;
  OnBoardingInfo(
      {required this.image,
      required this.title,
      required this.description,
      this.button});
}

class OnboardingItems {
  List<OnBoardingInfo> items = [
    OnBoardingInfo(
        title: "Any Where You Are",
        description:
            'Get a ride at your doorstep, anytime, anywhere. Fast, reliable, and always at your service!.',
        image: "assets/images/Anywhere you are.png"),
    OnBoardingInfo(
        title: 'At Any Time',
        description:
            "Book your ride whenever you need it, day or night. We're always here to take you where you want to go!",
        image: "assets/images/At anytime.png"),
    OnBoardingInfo(
        title: 'Book Your Ride',
        description:
            'Choose your ride with just a few taps. Enjoy a smooth and personalized booking experience tailored to you!',
        image: "assets/images/Frame 1.png"),
  ];
}

class CustomCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final Color backgroundColor;

  const CustomCircleButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.iconColor = Colors.white,
    this.iconSize = 24.0,
    this.backgroundColor = ThemeColors.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
