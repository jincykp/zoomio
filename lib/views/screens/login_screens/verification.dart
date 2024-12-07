import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  // Function to check email verification
  Future<void> _checkEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        setState(() {
          isVerified = true;
        });
      }
    }
  }

  // Function to resend the verification email
  Future<void> _resendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent!')),
      );
    }
  }

  // Function to handle verification check and navigation
  Future<void> _handleVerification(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              email: widget.email,
              displayName: null, // No display name
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Email Not Verified'),
              content: const Text(
                'Your email is not verified yet. Please check your email or resend the verification link.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resendVerificationEmail();
                  },
                  child: const Text('Resend Email'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            child: Column(
              children: [
                const Spacer(),
                // Lottie Animation
                SizedBox(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.4,
                  child: Lottie.asset(
                    "assets/images/Animation - 1733482111651.json",
                  ),
                ),
                const SizedBox(height: 20),

                // Verification Message
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "A verification email has been sent to your email. "
                    "Please check your email and click the verification link to verify your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: ThemeColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // "Yes, I have verified it" Button
                SizedBox(
                  width: screenWidth * 0.7,
                  child: CustomButtons(
                    text: "Yes, I have verified it.",
                    onPressed: () => _handleVerification(context),
                    backgroundColor: ThemeColors.primaryColor,
                    textColor: ThemeColors.textColor,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
