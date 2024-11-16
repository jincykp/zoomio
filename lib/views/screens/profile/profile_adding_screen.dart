import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:zoomer/model/database_methods.dart';

import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/custom_widgets/cus_pro.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class AddProfileDetails extends StatefulWidget {
  const AddProfileDetails({super.key});

  @override
  State<AddProfileDetails> createState() => _AddProfileDetailsState();
}

class _AddProfileDetailsState extends State<AddProfileDetails> {
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final cityController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final districtController = TextEditingController();

  List<String> genderItems = ["Male", "Female", "Others"];
  File? _image; // Variable to hold the selected image

  // Default image path
  final String defaultImagePath = 'assets/person.png';

  // Global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the selected image
      });
    }
  }

  // Function to upload image and save profile details
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // Validate the form
      _formKey.currentState!.save(); // Save form state

      String imageUrl = '';

      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Upload the image to Firebase Storage if an image is selected
        if (_image != null) {
          print("Image path: ${_image!.path}"); // Log the image path
          String fileName =
              'profile_images/${DateTime.now().millisecondsSinceEpoch}_${randomAlphaNumeric(10)}.jpg';
          final ref = FirebaseStorage.instance.ref().child(fileName);
          await ref.putFile(_image!);
          imageUrl =
              await ref.getDownloadURL(); // Get the URL of the uploaded image
        } else {
          // Optionally set a default image URL or handle accordingly
          imageUrl =
              'default_image_url'; // Replace with your default image URL if any
        }

        String id = randomAlphaNumeric(10);
        Map<String, dynamic> userProfile = {
          "id": id,
          "name": nameController.text.trim(),
          "mobileNumber": mobileNumberController.text.trim(),
          "gender": genderController.text.trim(),
          "city": cityController.text.trim(),
          "district": districtController.text.trim(),
          "imageUrl": imageUrl, // Include the image URL
          "createdAt": FieldValue.serverTimestamp(), // Optional: Add timestamp
        };

        // Use consistent collection name
        await DatabaseMethod().addUserDetails(userProfile, id);

        // Close the loading indicator
        Navigator.of(context).pop();

        // Optionally navigate to the Home Page or show a success message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const HomePage(), // Replace with your home page
          ),
        );
      } catch (e) {
        // Close the loading indicator
        Navigator.of(context).pop();

        // Handle errors (e.g., show a snackbar or dialog)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    cityController.dispose();
    mobileNumberController.dispose();
    districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.030),
        child: SingleChildScrollView(
          child: Form(
            // Wrap the input fields in a Form widget
            key: _formKey, // Assign the GlobalKey
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: ThemeColors.textColor,
                      radius: 70,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : AssetImage(defaultImagePath)
                              as ImageProvider, // Show selected image if available or default image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeColors.primaryColor,
                        ),
                        child: IconButton(
                          onPressed: _pickImage, // Call pick image function
                          icon: const Icon(Icons.add_a_photo_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomprofileTextFormFields(
                  controller: nameController,
                  hintText: "Name",
                  labelText: "Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Name can only contain letters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomprofileTextFormFields(
                  keyBoardType: TextInputType.phone,
                  controller: mobileNumberController,
                  hintText: "Mobile Number",
                  labelText: "Mobile Number",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your street';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomprofileTextFormFields(
                  readOnly: true,
                  controller: genderController,
                  hintText: 'Gender',
                  labelText: "Gender",
                  suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      setState(() {
                        genderController.text =
                            value; // Update the TextField with the selected value
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return genderItems.map((String items) {
                        return PopupMenuItem<String>(
                          value: items,
                          child: Text(items),
                        );
                      }).toList();
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomprofileTextFormFields(
                  controller: cityController,
                  hintText: "City",
                  labelText: "City",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomprofileTextFormFields(
                  controller: districtController,
                  hintText: "District",
                  labelText: "District",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your district';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomButtons(
                  text: "Save",
                  onPressed: _saveProfile, // Call the save function
                  backgroundColor: ThemeColors.primaryColor,
                  textColor: ThemeColors.textColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
