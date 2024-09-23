import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';

class CustomPassword extends StatelessWidget {
  final String label;
  final bool icConfirmPassword;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  const CustomPassword(
      {super.key,
      required this.label,
      required this.controller,
      this.icConfirmPassword = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label ';
        }
        if (icConfirmPassword && value != controller.text) {
          return "Password do not match";
        }
        return validator?.call(value);
      },
    );
  }
}
