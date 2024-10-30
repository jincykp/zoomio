import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomprofileTextFormFields extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  String? labelText;
  String? Function(String?)? validator;
  Widget? prefixIcon;
  Widget? suffixIcon;
  final bool readOnly;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputFormatters;
  CustomprofileTextFormFields(
      {super.key,
      required this.controller,
      this.validator,
      required this.hintText,
      this.labelText,
      this.prefixIcon,
      this.inputFormatters,
      this.suffixIcon,
      this.keyBoardType,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyBoardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      readOnly: readOnly,
      validator: validator,
      inputFormatters: inputFormatters,
      onTap: readOnly
          ? () {
              FocusScope.of(context).requestFocus(FocusNode());
            }
          : null,
    );
  }
}
