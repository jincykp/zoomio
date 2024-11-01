import 'package:flutter/material.dart';

class ThemeColors {
  static const Color primaryColor = Color.fromARGB(255, 219, 168, 0);
  static const Color textColor = Colors.white;
  static const Color titleColor = Colors.black;
  static const Color alertColor = Colors.red;
}

class Textstyles {
  static const TextStyle titleText = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: ThemeColors.textColor);

  static const TextStyle titleTextSmall = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w400, color: ThemeColors.textColor);

  static const TextStyle bodytext = TextStyle(
    fontSize: 16,
    color: ThemeColors.textColor,
  );
  static const TextStyle warningText = TextStyle(
    fontSize: 12,
    color: Color.fromARGB(255, 216, 30, 30),
  );

  static const TextStyle buttonText =
      TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600);

  static const TextStyle smallTexts =
      TextStyle(fontSize: 10, color: Colors.white);
  static const TextStyle spclTexts =
      TextStyle(fontSize: 12, color: Color.fromARGB(255, 238, 100, 90));
  static const TextStyle gText =
      TextStyle(fontFamily: "FamilyGuy", fontSize: 16);
  static const TextStyle gTextdescription = TextStyle(
      fontFamily: "Rowdies", fontWeight: FontWeight.bold, fontSize: 13);
  static const TextStyle uniqueTitiles =
      TextStyle(fontFamily: "Itim", fontWeight: FontWeight.bold, fontSize: 22);
  static const TextStyle signText = TextStyle(
      fontFamily: "Rowdies", fontWeight: FontWeight.bold, fontSize: 18);
}
