import 'package:flutter/material.dart';
import 'package:zoomer/screens/login_screens/sign_in_screen.dart';
import 'package:zoomer/screens/login_screens/sign_up_screen.dart';
import 'package:zoomer/styles/appstyles.dart';

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
                "assets/Welcome Screen.png",
                height: screenHeight * 0.4,
              ),
              Text(
                'Welcome',
                style:
                    Textstyles.titleText.copyWith(fontSize: screenWidth * 0.06),
              ),
              Text(
                'Have a better sharing experience',
                style:
                    Textstyles.bodytext.copyWith(fontSize: screenWidth * 0.03),
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
                        side: BorderSide(width: screenWidth * 0.005),
                        backgroundColor: ThemeColors.primaryColor,
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: Text(
                      "Create an account",
                      style: TextStyle(
                          color: ThemeColors.textColor,
                          fontSize: screenWidth * 0.03),
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
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02)),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                          color: ThemeColors.primaryColor,
                          fontSize: screenWidth * 0.03),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
