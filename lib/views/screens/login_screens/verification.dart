import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/login_screens/bloc/auth_bloc.dart';
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
    // context.read<AuthBloc>().add(VerifyEmail());
  }

  // // Function to check email verification
  // Future<void> _checkEmailVerification() async {
  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     await user.reload();
  //     if (user.emailVerified) {
  //       setState(() {
  //         isVerified = true;
  //       });
  //     }
  //   }
  // }

  // Function to resend the verification email
  // Future<void> _resendVerificationEmail() async {
  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     await user.sendEmailVerification();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Verification email sent!')),
  //     );
  //   }
  // }

  // Function to handle verification check and navigation
  // Future<void> _handleVerification(BuildContext context) async {
  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     await user.reload();
  //     if (user.emailVerified) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => HomePage(
  //             email: widget.email,
  //             displayName: null, // No display name
  //           ),
  //         ),
  //       );
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Email Not Verified'),
  //             content: const Text(
  //               'Your email is not verified yet. Please check your email or resend the verification link.',
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   context.read<AuthBloc>().add(ResendVerificationEmail());
  //                 },
  //                 child: const Text('Resend Email'),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('Cancel'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Show loading indicator if needed
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          } else if (state is AuthError) {
            // First dismiss loading dialog if it's showing
            Navigator.of(context).pop();

            // Then show the not verified dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Email Not Verified!',
                    style: TextStyle(
                        color: ThemeColors.primaryColor,
                        fontWeight: FontWeight.w300),
                  ),
                  content: const Text(
                    'Your email is not verified yet. Please check your email or resend the verification link.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(ResendVerificationEmail());
                        Navigator.of(context).pop();
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
          } else if (state is EmailVerified) {
            // If loading dialog is showing, dismiss it
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }

            // Navigate to home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  email: widget.email,
                  displayName: null,
                ),
              ),
            );
            // } else if (state is VerificationEmailResent) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text(state.message)),
            //   );
          }
        },
        child: Scaffold(
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
                        onPressed: () {
                          context.read<AuthBloc>().add(VerifyEmail());
                        },
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
        ));
  }
}
