// lib/screens/sign_up_screen.dart
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoomer/controllers/auth_services.dart';
import 'package:zoomer/custom_widgets/custom_buttons.dart';
import 'package:zoomer/custom_widgets/custom_password.dart';
import 'package:zoomer/custom_widgets/textformformfields.dart';
import 'package:zoomer/screens/login_screens/sign_in_screen.dart';
import 'package:zoomer/screens/otp_verification/phn_verification.dart';
import 'package:zoomer/styles/appstyles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final AuthServices auth = AuthServices();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phnController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sign up",
                    style: Textstyles.bodytext
                        .copyWith(fontSize: screenWidth * 0.05)),
                SizedBox(height: screenHeight * 0.02),
                Textformformfields(
                  controller: emailController,
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    final bool isValid =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value);
                    if (!isValid) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.012),
                Textformformfields(
                  keyBoardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  controller: phnController,
                  hintText: 'Your mobile number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    } else if (value.length != 10) {
                      return 'Contact number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.012),
                CustomPasswordTextFormFields(
                  hintText: "password",
                  controller: passWordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    } else if (value.contains(' ')) {
                      return 'Password cannot contain whitespace';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    LengthLimitingTextInputFormatter(6)
                  ],
                ),
                SizedBox(height: screenHeight * 0.012),
                CustomPasswordTextFormFields(
                  hintText: "confirm password",
                  controller: confirmPasswordController,
                  isConfirmPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    } else if (value.contains(' ')) {
                      return 'Password cannot contain whitespace';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    LengthLimitingTextInputFormatter(6)
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: Colors.green,
                      onChanged: (newBool) {
                        setState(() {
                          isChecked = newBool;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                          "By signing up, you agree to the Terms of service and Privacy policy."),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomButtons(
                  text: "Sign up",
                  onPressed: signUp,
                  backgroundColor: ThemeColors.primaryColor,
                  textColor: ThemeColors.textColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
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
                    GestureDetector(
                      onTap: () {
                        AuthServices().signInWithGoogle(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: ThemeColors.textColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          "assets/gimage.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text("Sign In",
                          style: TextStyle(color: ThemeColors.primaryColor)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goToOtpVerificationScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const OtpVerificationScreen()));
  }

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      if (isChecked != true) {
        // If the checkbox is not checked, show a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You must agree to the Terms of Service and Privacy Policy to proceed.',
              style: Textstyles.smallTexts,
            ),
            backgroundColor: ThemeColors.titleColor,
          ),
        );
        return; // Exit the method early
      }

      // Proceed with sign-up if checkbox is checked
      final user = await auth.createAccountWithEmail(
        emailController.text,
        passWordController.text,
      );

      if (user != null) {
        log("User created successfully");
        goToOtpVerificationScreen(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create account. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
