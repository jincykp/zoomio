// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
// import 'package:zoomer/views/screens/login_screens/mymap.dart';
// import 'package:zoomer/views/screens/login_screens/welcome.dart';
// import 'package:zoomer/views/screens/styles/appstyles.dart';

// class MapenableScreen extends StatelessWidget {
//   const MapenableScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Center(
//             child: Card(
//               child: SizedBox(
//                 width: screenWidth * 0.8,
//                 height: screenHeight * 0.8,
//                 child: Padding(
//                   padding: EdgeInsets.all(screenWidth * 0.06),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Image.asset(
//                         "assets/images/Location.png",
//                         width: screenWidth * 0.2,
//                       ),
//                       const Text(
//                         "Enable your location",
//                       ),
//                       const Text(
//                         "Choose your location to start finding the requests around you",
//                         textAlign: TextAlign.center,
//                       ),
//                       Column(
//                         children: [
//                           CustomButtons(
//                             text: "Use my location",
//                             onPressed: () async {
//                               bool hasPermission =
//                                   await _requestLocationPermission(
//                                       Permission.location, context);
//                               if (hasPermission) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const MapScreen(),
//                                   ),
//                                 );
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                         'Location permission is required to use this feature.'),
//                                   ),
//                                 );
//                               }
//                             },
//                             backgroundColor: ThemeColors.primaryColor,
//                             textColor: ThemeColors.textColor,
//                             screenWidth: screenWidth,
//                             screenHeight: screenHeight,
//                           ),
//                           SizedBox(height: screenHeight * 0.01),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const WelcomeScreen(),
//                                   ),
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 side: const BorderSide(
//                                   color: ThemeColors.primaryColor,
//                                   width: 1,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: screenHeight * 0.02),
//                               ),
//                               child: Text(
//                                 "Skip for now",
//                                 style: TextStyle(
//                                   fontSize: screenWidth * 0.03,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<bool> _requestLocationPermission(
//       Permission permission, BuildContext context) async {
//     final status = await permission.request();
//     return status.isGranted;
//   }
// }
import 'package:flutter/material.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/login_screens/welcome.dart';

import 'package:zoomer/views/screens/styles/appstyles.dart';

class MapenableScreen extends StatelessWidget {
  const MapenableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Card(
        // color: ThemeColors.primaryColor,
        child: SizedBox(
          width: screenWidth * 0.8,
          height: screenHeight * 0.8,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/images/Location.png",
                  width: screenWidth * 0.2,
                ),
                const Text(
                  "Enable your location",
                  // style: Textstyles.titleTextSmall,
                ),
                const Text(
                  "Choose your location to start find the request around you",
                  textAlign: TextAlign.center,
                  //style: Textstyles.smallTexts,
                ),
                Column(
                  children: [
                    CustomButtons(
                        text: "Use my location",
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const SignUpScreen()));
                        },
                        backgroundColor: ThemeColors.primaryColor,
                        textColor: ThemeColors.textColor,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  color: ThemeColors.primaryColor, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02)),
                          child: Text(
                            "Skip for now",
                            style: TextStyle(
                                //color: ThemeColors.textColor,
                                fontSize: screenWidth * 0.03),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
