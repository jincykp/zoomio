import 'package:flutter/material.dart';
import 'package:zoomer/views/screens/login_screens/sign_in.dart';

import 'package:zoomer/views/screens/login_screens/signup.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/images/Welcomescreen.png",
                height: screenHeight * 0.4,
              ),
              const Text('Welcome', style: Textstyles.uniqueTitiles),
              const Text(
                'Have a better sharing experience...',
                style: Textstyles.gTextdescription,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 70,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        // side: BorderSide(width: screenWidth * 0.005),
                        backgroundColor: ThemeColors.primaryColor,
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Text(
                      "Create an account",
                      style: TextStyle(
                        color: ThemeColors.textColor,
                      ),
                    )),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
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
                      "Sign In",
                      style: TextStyle(
                        color: ThemeColors.primaryColor,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
