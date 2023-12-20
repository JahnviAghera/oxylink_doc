import 'package:flutter/material.dart';

class DynamicLink extends StatelessWidget {
  final String text;
  final TextStyle style;
  final VoidCallback? onTap;
  final TextAlign textAlign;
  final Color? dynamicColor;

  const DynamicLink({
    required this.text,
    this.style = const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      height: 0,
    ),
    this.onTap,
    this.textAlign = TextAlign.right,
    this.dynamicColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 21,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          textAlign: textAlign,
          style: style.copyWith(
              color: dynamicColor
          ),
        ),
      ),
    );
  }
}