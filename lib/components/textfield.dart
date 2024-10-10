import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final TextCapitalization? textCapitalization;
  final VoidCallback? onTap;
  final int? maxLines;
  final String? hintText;
  final TextStyle? textStyle;     // Optional custom text style
  final TextStyle? hintTextStyle; // Optional custom hint text style

  const CommonTextField({
    Key? key,
    required this.controller,
    this.textInputAction,
    this.obscureText,
    this.textCapitalization,
    this.onTap,
    this.maxLines,
    this.hintText,
    this.textStyle,     // Text style parameter
    this.hintTextStyle, // Hint text style parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: primaryColor,
      textInputAction: textInputAction,
      scrollPadding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).viewInsets.bottom),
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      obscureText: obscureText ?? false,
      style: textStyle,     // Apply custom text style if provided
      decoration: InputDecoration(
        hintText: hintText,  // Set hintText here
        hintStyle: hintTextStyle, // Apply custom hint text style if provided
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      onTap: onTap,
      maxLines: maxLines ?? 1,  // Default to single-line input if maxLines is not provided
    );
  }
}
