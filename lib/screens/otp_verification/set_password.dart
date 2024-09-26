import 'package:flutter/material.dart';
import 'package:zoomer/custom_widgets/custom_buttons.dart';
import 'package:zoomer/custom_widgets/custom_password.dart';
import 'package:zoomer/screens/otp_verification/profile_creation.dart';
import 'package:zoomer/styles/appstyles.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final passWordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child: Column(
            //  crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Set New Password ",
                style: Textstyles.titleText,
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              const Text("Enter your password"),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              CustomPasswordTextFormFields(
                hintText: "password",
                controller: passWordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.contains(' ')) {
                    return 'Password cannot contain whitespace';
                  }
                  return null; // Password is valid
                },
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomPasswordTextFormFields(
                hintText: "confirm password",
                controller: confirmPasswordController,
                isConfirmPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.contains(' ')) {
                    return 'Password cannot contain whitespace';
                  }
                  return null; // Password is valid
                },
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              const Text(
                "Atleast 1 number or a special character",
                style: Textstyles.smallTexts,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomButtons(
                  text: "Register",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ProfileCreationScreen()));
                  },
                  backgroundColor: ThemeColors.primaryColor,
                  textColor: ThemeColors.textColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight)
            ],
          ),
        ),
      ),
    );
  }
}
