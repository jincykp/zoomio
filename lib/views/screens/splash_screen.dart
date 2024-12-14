import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zoomer/views/home_page.dart'; // HomePage screen import
import 'package:zoomer/views/screens/onboarding/onboarding_state.dart'; // Onboarding screen import

/// SplashScreen Widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// State for SplashScreen
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  /// Redirects user to the appropriate screen based on authentication status
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    // Check Firebase Authentication status
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Navigate to OnboardingView if user is not signed in
      _navigateToScreen(const OnboardingView());
    } else {
      // Navigate to HomePage if user is signed in
      _navigateToScreen(
        HomePage(email: user.email ?? 'Unknown'),
      );
    }
  }

  /// Navigates to the given screen
  void _navigateToScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    double screenWidth = MediaQuery.of(context).size.width;

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
