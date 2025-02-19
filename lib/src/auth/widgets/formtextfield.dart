import 'package:flutter/material.dart';

class Formtextfield extends StatelessWidget {
  final bool obscureText;
  final String obscuringCharacter;
  final String? label;
  final String? hintText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator; // Correct validator type

  const Formtextfield({
    super.key,
    this.obscureText = false,
    this.obscuringCharacter = '*',
    this.label,
    this.hintText,
    this.validator,
    this.controller, this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixIcon: suffixIcon,
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
