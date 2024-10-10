// import 'package:flutter/material.dart';
// import 'package:zoomer/custom_widgets/custom_buttons.dart';
// import 'package:zoomer/custom_widgets/custom_password.dart';
// import 'package:zoomer/screens/home_page.dart';
// import 'package:zoomer/styles/appstyles.dart';

// class SetNewPasswordScreen extends StatelessWidget {
//   const SetNewPasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final passWordController = TextEditingController();
//     final confirmPasswordController = TextEditingController();
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(screenWidth * 0.08),
//             child: Column(
//               children: [
//                 const Text(
//                   "Set New Password ",
//                   style: Textstyles.titleText,
//                 ),
//                 SizedBox(height: screenHeight * 0.06),
//                 const Text(
//                   "Set your password",
//                   style: Textstyles.smallTexts,
//                 ),
//                 SizedBox(height: screenHeight * 0.06),
//                 CustomPasswordTextFormFields(
//                   hintText: "password",
//                   controller: passWordController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     } else if (value.contains(' ')) {
//                       return 'Password cannot contain whitespace';
//                     }
//                     return null; // Password is valid
//                   },
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 CustomPasswordTextFormFields(
//                   hintText: "confirmpassword",
//                   controller: confirmPasswordController,
//                   isConfirmPassword: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     } else if (value.contains(' ')) {
//                       return 'Password cannot contain whitespace';
//                     }
//                     return null; // Password is valid
//                   },
//                 ),
//                 SizedBox(height: screenHeight * 0.025),
//                 const Text(
//                   "At least 1 number or a special character",
//                   style: Textstyles.smallTexts,
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 CustomButtons(
//                   text: "Register",
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const HomePage(),
//                       ),
//                     );
//                   },
//                   backgroundColor: ThemeColors.primaryColor,
//                   textColor: ThemeColors.textColor,
//                   screenWidth: screenWidth,
//                   screenHeight: screenHeight,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
