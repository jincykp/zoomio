// import 'dart:io'; // Import this for handling File operations.
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:zoomer/custom_widgets/custom_buttons.dart';
// import 'package:zoomer/custom_widgets/custom_profile_creation.dart';
// import 'package:zoomer/screens/home_page.dart';
// import 'package:zoomer/screens/login_screens/welcome_screen.dart';
// import 'package:zoomer/styles/appstyles.dart';

// class ProfileCreationScreen extends StatefulWidget {
//   const ProfileCreationScreen({super.key});

//   @override
//   State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
// }

// class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final cityController = TextEditingController();
//   final streetController = TextEditingController();
//   final districtController = TextEditingController();
//   File? selectedImage; // Store the picked image file

//   @override
//   void dispose() {
//     nameController.dispose();
//     cityController.dispose();
//     streetController.dispose();
//     districtController.dispose();
//     super.dispose();
//   }

//   // Function to save profile data to Firebase Firestore
//   Future<void> _saveProfileData() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         User? user = FirebaseAuth.instance.currentUser;

//         if (user != null) {
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(user.uid)
//               .set({
//             'name': nameController.text,
//             'street': streetController.text,
//             'city': cityController.text,
//             'district': districtController.text,
//           });

//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) => const HomePage()));
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Please log in to save profile data')),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving profile data: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: EdgeInsets.all(screenWidth * 0.05),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 70,
//                       backgroundColor: ThemeColors.textColor,
//                       backgroundImage: selectedImage != null
//                           ? FileImage(selectedImage!)
//                           : null,
//                       child: selectedImage == null
//                           ? const Icon(
//                               Icons.person,
//                               size: 70,
//                               color: Colors.white,
//                             )
//                           : null,
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: ThemeColors.primaryColor),
//                         child: IconButton(
//                           onPressed: () {
//                             addProfileImage();
//                           },
//                           icon: const Icon(Icons.add_a_photo_outlined),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 CustomprofileTextFormFields(
//                   controller: nameController,
//                   hintText: "Name",
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
//                       return 'Name can only contain letters';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 CustomprofileTextFormFields(
//                   controller: streetController,
//                   hintText: "Street",
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your street';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 CustomprofileTextFormFields(
//                   controller: cityController,
//                   hintText: "City",
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your city';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 CustomprofileTextFormFields(
//                   controller: districtController,
//                   hintText: "District",
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your district';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const WelcomeScreen()));
//                         },
//                         style: ElevatedButton.styleFrom(
//                             side: const BorderSide(
//                                 color: ThemeColors.primaryColor, width: 1),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                                 vertical: screenHeight * 0.02)),
//                         child: Text(
//                           "Cancel",
//                           style: TextStyle(
//                               color: ThemeColors.primaryColor,
//                               fontSize: screenWidth * 0.03),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: screenWidth * 0.02),
//                     Expanded(
//                       child: CustomButtons(
//                         text: "Save",
//                         onPressed: _saveProfileData,
//                         backgroundColor: ThemeColors.primaryColor,
//                         textColor: ThemeColors.textColor,
//                         screenWidth: screenWidth,
//                         screenHeight: screenHeight,
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Function to pick an image from the gallery
//   addProfileImage() async {
//     final imagePicker = ImagePicker();
//     final pickedImage =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         selectedImage = File(pickedImage.path); // Store the selected image file
//       });
//     }
//   }
// }
