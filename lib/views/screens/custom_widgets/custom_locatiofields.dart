import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoomer/views/screens/custom_widgets/textform.dart';

class CustomLocatiofields extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  String? Function(String?)? validator;
  Widget? prefixIcon;
  Widget? suffixIcon;
  final bool readOnly;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputFormatters;
  CustomLocatiofields(
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
    return Textformformfields(controller: controller, hintText: hintText);
  }
}
