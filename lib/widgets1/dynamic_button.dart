import 'package:flutter/material.dart';

class DynamicButton extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color? dynamicColor;
  final VoidCallback onPressed;
  final Color? dynamicTextColor;

  const DynamicButton({
    required this.text,
    this.style = const TextStyle(
      fontSize: 16,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
    ),
    this.dynamicColor,
    this.dynamicTextColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: dynamicColor ?? Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: Text(
          text,
          style: style.copyWith(
            color: dynamicTextColor != null ? Colors.white : style.color,
          ),
        ),
      ),
    );
  }
}