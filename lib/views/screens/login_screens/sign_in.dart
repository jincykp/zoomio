import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zoomer/services/auth_services.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/custom_widgets/cus_password.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/custom_widgets/signup_formfields.dart';
import 'package:zoomer/views/screens/forgot_pw.dart/click_otp.dart';
import 'package:zoomer/views/screens/login_screens/bloc/auth_bloc.dart';
import 'package:zoomer/views/screens/login_screens/signup.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final auth = AuthServices();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05), // Added space at top
                const Row(
                  children: [
                    Text(
                      "Sign In",
                      style: Textstyles.signText,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.04), // Increased spacing
                Textformformfields(
                  controller: emailController,
                  hintText: 'Enter your email',
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
                SizedBox(height: screenHeight * 0.02), // Increased spacing
                CustomPasswordTextFormFields(
                  hintText: "Enter your password",
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
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ClickOtpScreen()));
                        },
                        child: const Text(
                          "Forget Password?",
                          style: Textstyles.spclTexts,
                        )),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02), // Added spacing
                CustomButtons(
                    text: "Sign In",
                    onPressed: logIn,
                    backgroundColor: ThemeColors.primaryColor,
                    textColor: ThemeColors.textColor,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight),
                SizedBox(height: screenHeight * 0.03), // Added spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.01),
                      child: const Text("or"),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03), // Added spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(SignInWithGoogle());
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(8)),
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
                SizedBox(height: screenHeight * 0.03), // Added spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: ThemeColors.primaryColor),
                        ))
                  ],
                ),
                SizedBox(height: screenHeight * 0.05), // Added bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }

  logIn() async {
    // Check if the email and password fields are not empty
    if (emailController.text.isEmpty || passWordController.text.isEmpty) {
      log("Email and password cannot be empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: ThemeColors.titleColor,
          content: Text(
            "Email and password cannot be empty",
            style: Textstyles.smallTexts,
          ),
        ),
      );
      return;
    }

    // Attempt to log in the user
    try {
      final user = await auth.loginAccountWithEmail(
          emailController.text.trim(), passWordController.text.trim());

      // Check if login was successful
      if (user != null) {
        log("User Logged In: ${user.email}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        log("Login failed: User is null");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: ThemeColors.alertColor,
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Login failed. Please check your email and password.",
                  style: Textstyles.smallTexts),
            ),
          ),
        );
      }
    } catch (e) {
      log("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred during login: ${e.toString()}"),
        ),
      );
    }
  }
}
