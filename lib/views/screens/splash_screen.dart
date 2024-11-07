import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/onboarding/onboarding_state.dart';
// Make sure to import the HomePage screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    gotoLogin();
  }

  Future<void> gotoLogin() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Reduced delay for better user experience
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not signed in, navigate to Onboarding/Sign-in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingView()),
      );
    } else {
      // User is signed in, navigate to Home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(email: user.email ?? 'Unknown'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 168, 0),
      body: Center(
        child: Text(
          "zoomio",
          style: TextStyle(
            fontSize: screenWidth * 0.1,
            fontFamily: "FamilyGuy",
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
