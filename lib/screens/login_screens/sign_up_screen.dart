import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoomer/custom_widgets/custom_buttons.dart';
import 'package:zoomer/custom_widgets/textformformfields.dart';
import 'package:zoomer/styles/appstyles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phnController = TextEditingController();
  final genderController = TextEditingController();
  List<String> genderItems = ["Male", "Female", "Others"];
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Sign up",
                style:
                    Textstyles.bodytext.copyWith(fontSize: screenWidth * 0.05),
              ),
              SizedBox(height: screenHeight * 0.02),
              Textformformfields(
                controller: nameController,
                hintText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Name can only contain letters';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.01),
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
              SizedBox(height: screenHeight * 0.01),
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
              SizedBox(height: screenHeight * 0.01),
              Textformformfields(
                readOnly: true,
                controller: genderController,
                hintText: 'Gender',
                suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      setState(() {
                        genderController.text = value;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return genderItems.map((String items) {
                        return PopupMenuItem<String>(
                          value: items,
                          child: Text(items),
                        );
                      }).toList();
                    }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your gender';
                  }
                  return null;
                },
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
                      }),
                  const Expanded(
                    child: Text(
                        "By signing up. you agree to the Terms of service andPrivacy policy."),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomButtons(
                  text: "Sign up",
                  onPressed: () {},
                  backgroundColor: ThemeColors.primaryColor,
                  textColor: ThemeColors.textColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight),
              // SizedBox(height: screenHeight * 0.02),
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
                  Container(
                    // width: screenWidth * 0.001,
                    // height: screenHeight * 0.001,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: ThemeColors.textColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/Gmail.png"),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Sign In",
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
}
