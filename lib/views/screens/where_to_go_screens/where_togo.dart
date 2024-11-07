import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_locatiofields.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class WhereToGoScreen extends StatelessWidget {
  const WhereToGoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController pickupController = TextEditingController();
    final TextEditingController dropOffController = TextEditingController();

    return Scaffold(
      body: ListView(
        // Removed top padding, no SafeArea
        children: [
          Stack(
            children: [
              Container(
                height: screenHeight * 0.4,
                //color: Colors.grey,
              ),
              Container(
                height: screenHeight * 0.3,
                // color: Colors.amber,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.mapMarkerAlt,
                            color: ThemeColors.baseColor,
                          ),
                          SizedBox(
                            width: screenWidth * 0.04,
                          ),
                          Expanded(
                            child: CustomLocatiofields(
                              controller: pickupController,
                              hintText: "Pickup location",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.mapPin,
                            color: ThemeColors.successColor,
                          ),
                          SizedBox(
                            width: screenWidth * 0.04,
                          ),
                          Expanded(
                            child: CustomLocatiofields(
                              controller: dropOffController,
                              hintText: "Drop-off location",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
