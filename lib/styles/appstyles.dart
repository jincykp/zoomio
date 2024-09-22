import 'package:flutter/material.dart';

class ThemeColors {
  static const Color primaryColor = Color.fromARGB(255, 219, 168, 0);
  static const Color textColor = Colors.white;
  static const Color titleColor = Colors.black;
}

class Textstyles {
  static const TextStyle titleText = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: ThemeColors.textColor);
  static const TextStyle bodytext = TextStyle(
    fontSize: 16,
    color: ThemeColors.textColor,
  );
  static const TextStyle buttonText =
      TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600);
}
