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
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: Image.asset(
                    "assets/images/Welcomescreen.png",
                    height: screenHeight * 0.4,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Welcome', style: Textstyles.uniqueTitiles),
                    SizedBox(height: screenHeight * 0.01),
                    const Text(
                      'Have a better sharing experience...',
                      style: Textstyles.gTextdescription,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColors.primaryColor,
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Create an account",
                          style: TextStyle(
                              color: ThemeColors.textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: ThemeColors.primaryColor,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                        ),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                              color: ThemeColors.primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
