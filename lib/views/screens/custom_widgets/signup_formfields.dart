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
  final TextInputAction? textInputAction; // Added TextInputAction
  final ToolbarOptions? toolbarOptions; // Added ToolbarOptions

  Textformformfields({
    super.key,
    required this.controller,
    this.validator,
    required this.hintText,
    this.prefixIcon,
    this.inputFormatters,
    this.suffixIcon,
    this.keyBoardType,
    this.textInputAction = TextInputAction.next, // Default value
    this.readOnly = false,
    this.toolbarOptions, // New optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyBoardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      textInputAction: textInputAction, // Assigning textInputAction here
      toolbarOptions: toolbarOptions ??
          const ToolbarOptions(
            // Assigning default value
            copy: true,
            cut: false,
            paste: false,
            selectAll: true,
          ),
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
