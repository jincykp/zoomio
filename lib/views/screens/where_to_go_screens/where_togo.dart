import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
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
      // body: Column(
      //   children: [
      //     Container(
      //       padding: EdgeInsets.all(screenWidth * 0.10),
      //       height: screenHeight * 0.2,
      //       decoration: BoxDecoration(
      //           color: ThemeColors.primaryColor,
      //           borderRadius: BorderRadius.only(
      //               bottomLeft: Radius.circular(32),
      //               bottomRight: Radius.circular(32)),
      //           boxShadow: [
      //             BoxShadow(
      //                 color: Colors.grey,
      //                 offset: Offset(0.0, 1.0),
      //                 blurRadius: 6.0)
      //           ]),
      //       child: const Row(
      //         children: [
      //           Column(
      //             children: [
      //               Icon(
      //                 Icons.circle,
      //                 color: ThemeColors.baseColor,
      //                 size: 22,
      //               ),
      //               Icon(
      //                 Icons.square,
      //                 color: ThemeColors.successColor,
      //               )
      //             ],
      //           ),
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Divider(
      //                 color: ThemeColors.textColor,
      //               ),
      //             ],
      //           )
      //         ],
      //       ),
      //     )
      //   ],
      // ),
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
                height: screenHeight * 0.32,
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
                                hintStyle: Textstyles.bodytext,
                                suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.location_searching,
                                      color: ThemeColors.titleColor,
                                    ))),
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
                              hintStyle: Textstyles.bodytext,
                              suffixIcon: const Icon(
                                Icons.cancel,
                                color: ThemeColors.titleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      // SizedBox(
                      //   width: screenWidth * 0.5,
                      //   height: screenHeight * 0.06,
                      //   child: CustomButtons(
                      //       text: "Search",
                      //       onPressed: () {},
                      //       backgroundColor: ThemeColors.titleColor,
                      //       textColor: ThemeColors.textColor,
                      //       screenWidth: screenWidth * 0.03,
                      //       screenHeight: screenHeight * 0.03),
                      // )
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
