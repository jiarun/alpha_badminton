import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final IconData? prefixIcon;
  final EdgeInsetsGeometry? margin;

  CustomTextField({
    required this.controller, 
    required this.hint, 
    this.obscureText = false,
    this.prefixIcon,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}
