import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoomer/controllers/auth_services.dart';
import 'package:zoomer/custom_widgets/custom_buttons.dart';
import 'package:zoomer/custom_widgets/textformformfields.dart';
import 'package:zoomer/screens/forgot_password/forget_selection.dart';
import 'package:zoomer/screens/home_screen.dart';
import 'package:zoomer/styles/appstyles.dart';

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Sign In",
                style:
                    Textstyles.bodytext.copyWith(fontSize: screenWidth * 0.05),
              ),
              SizedBox(height: screenHeight * 0.02),
              Textformformfields(
                controller: emailController,
                hintText: 'Email or Phone Number',
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
              SizedBox(height: screenHeight * 0.01),
              Textformformfields(
                controller: passWordController,
                hintText: 'Enter your password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.contains(' ')) {
                    return 'Password cannot contain whitespace';
                  }
                  return null; // Password is valid
                },
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(r'\s')), // Deny whitespace
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordScreen()));
                      },
                      child: const Text(
                        "Forget Password?",
                        style: Textstyles.spclTexts,
                      )),
                ],
              ),
              CustomButtons(
                  text: "Sign In",
                  onPressed: logIn,
                  backgroundColor: ThemeColors.primaryColor,
                  textColor: ThemeColors.textColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      AuthServices().signInWithGoogle(context);
                    },
                    child: Container(
                      width: 50, height: 50,
                      // width: screenWidth * 0.001,
                      // height: screenHeight * 0.001,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: ThemeColors.textColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/gimage.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                //  crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: logIn,
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: ThemeColors.primaryColor),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  goToHome(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
        goToHome(context);
      } else {
        log("Login failed: User is null");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red, // Change this to your desired color
            content: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0), // Adjust padding as needed
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
            content: Text("An error occurred during login: ${e.toString()}")),
      );
    }
  }
}
