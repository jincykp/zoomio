import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_locatiofields.dart';

class CusLocationSearch extends StatelessWidget {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  void _onConfirmPressed() {
    // Your logic for when the confirm button is pressed
    print(
        "Confirmed with pickup location: ${_latController.text} and drop-off location: ${_lngController.text}");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          children: [
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.mapMarkerAlt,
                  color: Colors.green, // Replace with your color
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: CustomLocationFields(
                    controller: _latController,
                    hintText: "Pick up location",
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey), // Replace with your style
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.mapPin,
                  color: Colors.red, // Replace with your color
                  size: 25,
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: CustomLocationFields(
                    controller: _lngController,
                    hintText: "Drop off location",
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey), // Replace with your style
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: screenWidth * 0.5,
              height: screenHeight * 0.06,
              child: CustomButtons(
                text: "Confirm",
                onPressed: _onConfirmPressed,
                backgroundColor: Colors.blue, // Replace with your color
                textColor: Colors.white,
                screenWidth: screenWidth,
                screenHeight: screenHeight * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
