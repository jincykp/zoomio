import 'package:flutter/material.dart';
import 'package:zoomer/custom_widgets/custom_buttons.dart';
import 'package:zoomer/custom_widgets/textformformfields.dart';
import 'package:zoomer/screens/forgot_password/forget_selection.dart';
import 'package:zoomer/screens/home_screen.dart';
import 'package:zoomer/screens/login_screens/sign_up_screen.dart';
import 'package:zoomer/styles/appstyles.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final phnController = TextEditingController();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Sign In",
              style: Textstyles.bodytext.copyWith(fontSize: screenWidth * 0.05),
            ),
            SizedBox(height: screenHeight * 0.02),
            Textformformfields(
              label: "password",
              controller: phnController,
              hintText: 'Email or Phone Number',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return 'Name can only contain letters';
                }
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.01),
            Textformformfields(
              label: "password",
              controller: phnController,
              hintText: 'Enter your password',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordScreen()));
                    },
                    child: const Text(
                      "Forget Password?",
                      style: Textstyles.spclTexts,
                    )),
              ],
            ),
            CustomButtons(
                text: "Sign In",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
                backgroundColor: ThemeColors.primaryColor,
                textColor: ThemeColors.textColor,
                screenWidth: screenWidth,
                screenHeight: screenHeight),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.01),
                  child: const Text("or"),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // width: screenWidth * 0.001,
                  // height: screenHeight * 0.001,
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: ThemeColors.textColor),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/Gmail.png"),
                  ),
                )
              ],
            ),
            Row(
              //  crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: ThemeColors.primaryColor),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
