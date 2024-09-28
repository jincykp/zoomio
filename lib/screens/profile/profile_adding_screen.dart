import 'package:flutter/material.dart';
import 'package:zoomer/custom_widgets/custom_buttons.dart';
import 'package:zoomer/custom_widgets/custom_profile_creation.dart';
import 'package:zoomer/styles/appstyles.dart';

class AddProfileDetails extends StatefulWidget {
  const AddProfileDetails({super.key});
  @override
  State<AddProfileDetails> createState() => _AddProfileDetailsState();
}

class _AddProfileDetailsState extends State<AddProfileDetails> {
  @override
  Widget build(BuildContext context) {
    final nameControllers = TextEditingController();

    final cityControllers = TextEditingController();
    final streetControllers = TextEditingController();
    final districtControllers = TextEditingController();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.09),
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
              hintText: "Namess",
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
            SizedBox(width: screenWidth * 0.02),
            CustomButtons(
                text: "Save",
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const HomePage()));
                },
                backgroundColor: ThemeColors.primaryColor,
                textColor: ThemeColors.textColor,
                screenWidth: screenWidth,
                screenHeight: screenHeight)
          ],
        ),
      ),
    );
  }
}
