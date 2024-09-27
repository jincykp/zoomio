import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoomer/custom_widgets/custom_buttons.dart';
import 'package:zoomer/screens/otp_verification/set_password.dart';
import 'package:zoomer/styles/appstyles.dart';

class ClickOtpScreen extends StatefulWidget {
  const ClickOtpScreen({super.key});

  @override
  State<ClickOtpScreen> createState() => _ClickOtpScreenState();
}

class _ClickOtpScreenState extends State<ClickOtpScreen> {
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
                  text: "Verify",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SetPasswordScreen()));
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
