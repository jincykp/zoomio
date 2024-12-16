// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:zoomer/views/screens/custom_widgets/custom_locatiofields.dart';
// import 'package:zoomer/views/screens/custom_widgets/signup_formfields.dart';
// import 'package:zoomer/views/screens/styles/appstyles.dart';

// class ProfileCreationScreen extends StatefulWidget {
//   const ProfileCreationScreen({super.key});

//   @override
//   State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
// }

// class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _contactController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();

//   String? _profileImagePath;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text("Create Profile"),
//           centerTitle: true,
//           backgroundColor: ThemeColors.primaryColor),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: GestureDetector(
//                     onTap: _pickProfileImage,
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey.shade300,
//                       backgroundImage: _profileImagePath != null
//                           ? AssetImage(_profileImagePath!) as ImageProvider
//                           : null,
//                       child: _profileImagePath == null
//                           ? const Icon(
//                               Icons.camera_alt,
//                               size: 30,
//                               color: Colors.grey,
//                             )
//                           : null,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Textformformfields(
//                   controller: _nameController,
//                   hintText: "Enter your name",
//                   prefixIcon: const Icon(Icons.person),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Name cannot be empty";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Textformformfields(
//                   controller: _contactController,
//                   hintText: "Enter your contact number",
//                   prefixIcon: const Icon(Icons.phone),
//                   keyBoardType: TextInputType.phone,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Contact number cannot be empty";
//                     }
//                     if (value.length < 10) {
//                       return "Enter a valid contact number";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Textformformfields(
//                   controller: _addressController,
//                   hintText: "Enter your address",
//                   prefixIcon: const Icon(Icons.location_on),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Address cannot be empty";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Textformformfields(
//                   controller: _emailController,
//                   hintText: "Enter your email ID",
//                   prefixIcon: const Icon(Icons.email),
//                   keyBoardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Email ID cannot be empty";
//                     }
//                     if (!RegExp(
//                             r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$")
//                         .hasMatch(value)) {
//                       return "Enter a valid email address";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Textformformfields(
//                   controller: _ageController,
//                   hintText: "Enter your age",
//                   prefixIcon: const Icon(Icons.cake),
//                   keyBoardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Age cannot be empty";
//                     }
//                     if (int.tryParse(value) == null || int.parse(value) <= 0) {
//                       return "Enter a valid age";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: _saveProfile,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.teal,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 14.0,
//                         horizontal: 30.0,
//                       ),
//                     ),
//                     child: const Text(
//                       "Save Profile",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _pickProfileImage() {
//     // Add your image picker logic here
//     setState(() {
//       _profileImagePath = 'assets/images/profile-placeholder.png'; // Example
//     });
//   }

//   void _saveProfile() {
//     if (_formKey.currentState?.validate() ?? false) {
//       // Save profile logic here
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile saved successfully!")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields correctly")),
//       );
//     }
//   }
// }
