import 'package:flutter/material.dart';
import 'package:zoomer/controllers/authservices.dart';
import 'package:zoomer/presentations/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/presentations/screens/custom_widgets/textform.dart';

import 'package:zoomer/presentations/screens/styles/appstyles.dart';

class ClickOtpScreen extends StatefulWidget {
  const ClickOtpScreen({super.key});

  @override
  State<ClickOtpScreen> createState() => _ClickOtpScreenState();
}

class _ClickOtpScreenState extends State<ClickOtpScreen> {
  final auth = AuthServices();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child: Column(
            children: [
              const Text(
                "Enter email to send you a password reset email",
                style: Textstyles.titleTextSmall,
              ),
              SizedBox(
                height: screenWidth * 0.1,
              ),
              Textformformfields(
                  controller: emailController, hintText: "Enter your Email"),
              SizedBox(
                height: screenWidth * 0.1,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     SizedBox(
              //       height: 68,
              //       width: 64,
              //       child: TextFormField(
              //         onChanged: (value) {
              //           if (value.length == 1) {
              //             FocusScope.of(context).nextFocus();
              //           }
              //         },
              //         style: Theme.of(context).textTheme.titleLarge,
              //         keyboardType: TextInputType.number,
              //         textAlign: TextAlign.center,
              //         inputFormatters: [
              //           LengthLimitingTextInputFormatter(1),
              //           FilteringTextInputFormatter.digitsOnly
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       height: 68,
              //       width: 64,
              //       child: TextField(
              //         onChanged: (value) {
              //           if (value.length == 1) {
              //             FocusScope.of(context).nextFocus();
              //           }
              //         },
              //         style: Theme.of(context).textTheme.titleLarge,
              //         keyboardType: TextInputType.number,
              //         textAlign: TextAlign.center,
              //         inputFormatters: [
              //           LengthLimitingTextInputFormatter(1),
              //           FilteringTextInputFormatter.digitsOnly
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       height: 68,
              //       width: 64,
              //       child: TextField(
              //         onChanged: (value) {
              //           if (value.length == 1) {
              //             FocusScope.of(context).nextFocus();
              //           }
              //         },
              //         style: Theme.of(context).textTheme.titleLarge,
              //         keyboardType: TextInputType.number,
              //         textAlign: TextAlign.center,
              //         inputFormatters: [
              //           LengthLimitingTextInputFormatter(1),
              //           FilteringTextInputFormatter.digitsOnly
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       height: 68,
              //       width: 64,
              //       child: TextField(
              //         onChanged: (value) {
              //           if (value.length == 1) {
              //             FocusScope.of(context).nextFocus();
              //           }
              //         },
              //         style: Theme.of(context).textTheme.titleLarge,
              //         keyboardType: TextInputType.number,
              //         textAlign: TextAlign.center,
              //         inputFormatters: [
              //           LengthLimitingTextInputFormatter(1),
              //           FilteringTextInputFormatter.digitsOnly
              //         ],
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     const Text(
              //       "Didn't receive code?",
              //       style: Textstyles.smallTexts,
              //     ),
              //     TextButton(
              //         onPressed: () {},
              //         child: const Text(
              //           "Resend again",
              //           style: Textstyles.spclTexts,
              //         ))
              //   ],
              // ),

              CustomButtons(
                  text: "Send Email",
                  onPressed: () async {
                    await auth.resetPassword(emailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'An email for password reset has been sent to your email.',
                          style: Textstyles.smallTexts,
                        ),
                        backgroundColor: ThemeColors.titleColor,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  backgroundColor: ThemeColors.primaryColor,
                  textColor: ThemeColors.textColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight)
            ],
          ),
        ),
      ),
    );
  }
}
