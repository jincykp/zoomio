import 'package:flutter/material.dart';
import 'package:zoomer/custom_widgets/custom_buttons.dart';
import 'package:zoomer/custom_widgets/custom_profile_creation.dart';
import 'package:zoomer/screens/home_screen.dart';
import 'package:zoomer/screens/login_screens/welcome_screen.dart';
import 'package:zoomer/styles/appstyles.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  @override
  Widget build(BuildContext context) {
    final nameControllers = TextEditingController();
    final emailControllers = TextEditingController();
    final cityControllers = TextEditingController();
    final streetControllers = TextEditingController();
    final districtControllers = TextEditingController();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    backgroundColor: ThemeColors.textColor,
                    radius: 70,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ThemeColors.primaryColor),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add_a_photo_outlined)),
                      ))
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomprofileTextFormFields(
                controller: nameControllers,
                hintText: "Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Name can only contain letters';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomprofileTextFormFields(
                  controller: emailControllers,
                  hintText: "Email",
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
                  }),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomprofileTextFormFields(
                controller: streetControllers,
                hintText: "Street",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your street';
                  }

                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomprofileTextFormFields(
                controller: cityControllers,
                hintText: "City",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }

                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomprofileTextFormFields(
                controller: districtControllers,
                hintText: "District",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your district';
                  }

                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WelcomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                                color: ThemeColors.primaryColor, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02)),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: ThemeColors.primaryColor,
                              fontSize: screenWidth * 0.03),
                        )),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: CustomButtons(
                        text: "Save",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        backgroundColor: ThemeColors.primaryColor,
                        textColor: ThemeColors.textColor,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
