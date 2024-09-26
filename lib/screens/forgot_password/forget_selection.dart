import 'package:flutter/material.dart';
import 'package:zoomer/custom_widgets/custom_buttons.dart';
import 'package:zoomer/screens/forgot_password/click_otp.dart';
import 'package:zoomer/screens/forgot_password/set_new_password.dart';
import 'package:zoomer/screens/otp_verification/phn_verification.dart';
import 'package:zoomer/styles/appstyles.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Forgot Password",
                style: Textstyles.titleTextSmall,
              ),
              const Text(
                  "Select which contact details should we use to reset your password."),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              SizedBox(
                height: screenHeight * 0.15,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: ListTile(
                      onTap: () {},
                      leading: const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage("assets/phnmsg.png"),
                      ),
                      title: const Text("Via SMS"),
                      subtitle: const Text("**** ****76"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              SizedBox(
                height: screenHeight * 0.15,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: ListTile(
                      onTap: () {},
                      leading: const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage("assets/phnmsg.png"),
                      ),
                      title: const Text("Via Email"),
                      subtitle: const Text("******@gmail.com"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.29,
              ),
              CustomButtons(
                  text: "Continue",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClickOtpScreen()));
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
