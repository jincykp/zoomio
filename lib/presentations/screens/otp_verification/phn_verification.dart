// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:zoomer/controllers/auth_services.dart';
// import 'package:zoomer/custom_widgets/custom_buttons.dart';
// import 'package:zoomer/screens/home_page.dart';
// import 'package:zoomer/styles/appstyles.dart';

// class OtpVerificationScreen extends StatefulWidget {
//   const OtpVerificationScreen({super.key});

//   @override
//   State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final auth = AuthServices();
//   late Timer timer;
//   @override
//   void initState() {
//     auth.sendEailVerificationLink();
//     timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       FirebaseAuth.instance.currentUser?.reload();
//       if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
//         timer.cancel();
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => const HomePage()));
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.08),
//           child: Column(
//             children: [
//               const Text(
//                 "Phone verification ",
//                 style: Textstyles.titleText,
//               ),
//               SizedBox(
//                 height: screenHeight * 0.04,
//               ),
//               const Text("Enter your OTP code"),
//               SizedBox(
//                 height: screenHeight * 0.01,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(
//                     height: 68,
//                     width: 64,
//                     child: TextFormField(
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       style: Theme.of(context).textTheme.titleLarge,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 68,
//                     width: 64,
//                     child: TextField(
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       style: Theme.of(context).textTheme.titleLarge,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 68,
//                     width: 64,
//                     child: TextField(
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       style: Theme.of(context).textTheme.titleLarge,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 68,
//                     width: 64,
//                     child: TextField(
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       style: Theme.of(context).textTheme.titleLarge,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Text(
//                     "Didn't receive code?",
//                     style: Textstyles.smallTexts,
//                   ),
//                   TextButton(
//                       onPressed: () {
//                         auth.sendEailVerificationLink();
//                       },
//                       child: const Text(
//                         "Resend again",
//                         style: Textstyles.spclTexts,
//                       ))
//                 ],
//               ),
//               CustomButtons(
//                   text: "Verify",
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 const ProfileCreationScreen()));
//                   },
//                   backgroundColor: ThemeColors.primaryColor,
//                   textColor: ThemeColors.textColor,
//                   screenWidth: screenWidth,
//                   screenHeight: screenHeight)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
