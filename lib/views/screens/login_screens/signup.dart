import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoomer/services/auth_services.dart';
import 'package:zoomer/services/userservices.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/bottom_screens/home_screen.dart';
import 'package:zoomer/views/screens/custom_widgets/cus_password.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/custom_widgets/textform.dart';
import 'package:zoomer/views/screens/login_screens/sign_in.dart';
import 'package:zoomer/views/screens/login_screens/verification.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final AuthServices auth = AuthServices();
  final UserService userService = UserService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight, // Ensures the content fills the screen
            ),
            child: IntrinsicHeight(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Sign up", style: Textstyles.signText),
                    SizedBox(height: screenHeight * 0.02),

                    // Email field
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

                    // Password field
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
                    SizedBox(height: screenHeight * 0.013),

                    // Confirm Password field
                    CustomPasswordTextFormFields(
                      hintText: "confirm password",
                      controller: confirmPasswordController,
                      isConfirmPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value != passWordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        LengthLimitingTextInputFormatter(6)
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Checkbox for Terms of Service
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
                    SizedBox(height: screenHeight * 0.03),

                    // Sign Up button
                    CustomButtons(
                      text: "Sign up",
                      onPressed: () async {
                        if (formKey.currentState!.validate() &&
                            isChecked == true) {
                          try {
                            // Call createAccountWithEmail
                            User? user = await auth.createAccountWithEmail(
                              emailController.text,
                              passWordController.text,
                            );

                            if (user != null) {
                              // Save user details
                              await userService.saveUserDetails(
                                user.uid,
                                emailController.text,
                                "",
                              );
                              print("User details saved to Firestore.");

                              // Navigate to the next screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerificationScreen(
                                    email: emailController.text,
                                  ), // Or VerificationScreen
                                ),
                              );
                              print("Navigation to HomePage completed.");
                            } else {
                              print("User creation failed. User is null.");
                            }
                          } catch (e) {
                            print("Error during signup: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Sign-up failed. Please try again later.',
                                  style: Textstyles.smallTexts,
                                ),
                                backgroundColor: ThemeColors.titleColor,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'You must agree to the Terms of Service and Privacy Policy to proceed.',
                                style: Textstyles.smallTexts,
                              ),
                              backgroundColor: ThemeColors.titleColor,
                            ),
                          );
                        }
                      },
                      backgroundColor: ThemeColors.primaryColor,
                      textColor: ThemeColors.textColor,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    // Divider or "or" section
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

                    // Google Sign-In button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            AuthServices().signInWithGoogle(context);
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors
                                        .black // Light theme: border is black
                                    : Colors
                                        .white, // Dark theme: border is white
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/images/gimage.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    // Already have an account? Sign In link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            );
                          },
                          child: const Text("Sign In",
                              style:
                                  TextStyle(color: ThemeColors.primaryColor)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
