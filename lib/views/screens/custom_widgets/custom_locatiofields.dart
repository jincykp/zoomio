import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomLocationFields extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;
  final void Function(String)? onChanged; // Add this line

  CustomLocationFields({
    super.key,
    required this.controller,
    this.validator,
    required this.hintText,
    this.prefixIcon,
    this.inputFormatters,
    this.suffixIcon,
    this.keyBoardType,
    this.readOnly = false,
    this.hintStyle,
    this.onChanged, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Make sure to add the controller
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyBoardType,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged, // Pass the onChanged function here
    );
  }
}
