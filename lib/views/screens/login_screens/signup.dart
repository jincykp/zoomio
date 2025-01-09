import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomer/services/auth_services.dart';
import 'package:zoomer/services/userservices.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/bottom_screens/home_screen.dart';
import 'package:zoomer/views/screens/custom_widgets/cus_password.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/custom_widgets/signup_formfields.dart';
import 'package:zoomer/views/screens/login_screens/bloc/auth_bloc.dart';
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
  final TextEditingController contactController = TextEditingController();
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is AuthError) {
            // Hide loading indicator and show error
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: Textstyles.smallTexts,
                ),
                backgroundColor: ThemeColors.titleColor,
              ),
            );
          } else if (state is EmailVerificationSent) {
            // Hide loading indicator and navigate to verification screen
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(
                  email: state.email,
                ),
              ),
            );
          } else if (state is AuthSuccess) {
            // Hide loading indicator and navigate to home
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  email: state.email,
                  displayName: state.displayName,
                ),
              ),
            );
          }
        },
        child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        screenHeight, // Ensures the content fills the screen
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
                            onPressed: () {
                              if (formKey.currentState!.validate() &&
                                  isChecked == true) {
                                context.read<AuthBloc>().add(
                                      SignUpWithEmailPassword(
                                        email: emailController.text,
                                        password: passWordController.text,
                                      ),
                                    );
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
                                  context
                                      .read<AuthBloc>()
                                      .add(SignInWithGoogle());
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
                                        builder: (context) =>
                                            const SignInScreen()),
                                  );
                                },
                                child: const Text("Sign In",
                                    style: TextStyle(
                                        color: ThemeColors.primaryColor)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}
