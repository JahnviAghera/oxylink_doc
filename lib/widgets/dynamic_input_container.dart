import 'package:flutter/material.dart';

TextField buildDynamicInputContainer({
  required String hintText,
  TextInputType inputType = TextInputType.text,
  bool obscureText = false,
  Function(String)? onChanged,
  Widget? icon,
  VoidCallback? onIconTap,
  TextEditingController? controller, // Added controller parameter
}) {
  return TextField(
    keyboardType: inputType,
    obscureText: obscureText,
    onChanged: onChanged,
    controller: controller, // Use the provided controller
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: hintText,
      labelStyle: TextStyle(
        color: Color(0xFF070707),
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
      suffixIcon: onIconTap != null
          ? InkWell(
        onTap: onIconTap,
        child: icon ?? Icon(Icons.visibility),
      )
          : null,
    ),
  );
}
