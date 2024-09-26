import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Textformformfields extends StatelessWidget {
  TextEditingController controller;
  String hintText;

  String? Function(String?)? validator;
  Widget? prefixIcon;
  Widget? suffixIcon;
  final bool readOnly;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputFormatters;
  Textformformfields(
      {super.key,
      required this.controller,
      this.validator,
      required this.hintText,
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
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(19)),
        ),
        hintText: hintText,
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
