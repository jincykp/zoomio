import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomer/services/auth_services.dart';
import 'package:zoomer/services/userservices.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/custom_widgets/cus_password.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/custom_widgets/signup_formfields.dart';
import 'package:zoomer/views/screens/drawer_screens/privacy_ppolicy.dart';
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

  void _showPrivacyPolicy(BuildContext context) {
    // Use a post-frame callback to ensure the dialog is built after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: true, // Allow dismissing by tapping outside
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: MediaQuery.of(dialogContext).size.width *
                  0.9, // Explicit width constraint
              height: MediaQuery.of(dialogContext).size.height *
                  0.7, // Explicit height constraint
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: const PrivacyPolicyContent(),
                  ),
                  TextButton(
                    child: const Text(
                      "Accept",
                      style: TextStyle(
                          color:
                              Colors.blue), // Use your ThemeColors.primaryColor
                    ),
                    onPressed: () {
                      // Use a callback to setState outside the dialog context
                      Navigator.of(dialogContext)
                          .pop(true); // Return true when accepted
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ).then((accepted) {
        // Handle the result outside the dialog
        if (accepted == true) {
          setState(() {
            isChecked = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ThemeColors.primaryColor),
              ),
            ),
          );
        } else if (state is AuthError) {
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          textInputAction: TextInputAction.next,
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            cut: true,
                            paste: false,
                            selectAll: true,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.012),

                        // Password field
                        CustomPasswordTextFormFields(
                          hintText: "Password",
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
                          textInputAction: TextInputAction.next,
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            cut: false,
                            paste: false,
                            selectAll: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            LengthLimitingTextInputFormatter(6)
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.013),

                        // Confirm Password field
                        CustomPasswordTextFormFields(
                          hintText: "Confirm password",
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
                          textInputAction: TextInputAction.next,
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            cut: false,
                            paste: false,
                            selectAll: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            LengthLimitingTextInputFormatter(6)
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // Checkbox for Terms of Service with clickable links
                        Row(
                          children: [
                            Container(
                              height: 24,
                              width: 24,
                              child: Material(
                                type: MaterialType.transparency,
                                child: Checkbox(
                                  value: isChecked ?? false,
                                  activeColor: Colors.green,
                                  onChanged: (newBool) {
                                    setState(() {
                                      isChecked = newBool;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text:
                                            "By signing up, you agree to the "),
                                    TextSpan(
                                      text: "Terms of service",
                                      style: const TextStyle(
                                        color: ThemeColors.primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _showPrivacyPolicy(context);
                                        },
                                    ),
                                    const TextSpan(text: " and "),
                                    TextSpan(
                                      text: "Privacy policy",
                                      style: const TextStyle(
                                        color: ThemeColors.primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _showPrivacyPolicy(context);
                                        },
                                    ),
                                    const TextSpan(text: "."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // Sign Up button
                        CustomButtons(
                          text: "Sign up",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (isChecked == true) {
                                context.read().add(
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
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter your email and password.',
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
                                        ? Colors.black
                                        : Colors.white,
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
          ),
        ),
      ),
    );
  }
}
