import 'package:flutter/material.dart';

class CircleAvatarWithName extends StatelessWidget {
  final String fullName;

  CircleAvatarWithName({required this.fullName});

  @override
  Widget build(BuildContext context) {
    // Extracting the first letter of each word in the full name
    List<String> initials = fullName.split(' ').map((word) => word[0]).toList();

    // Combining the first letters to form the circle avatar text
    String avatarText = initials.join('');

    return CircleAvatar(
      backgroundColor: Colors.blue, // You can customize the color
      radius: 20, // You can adjust the size
      child: Text(
        avatarText,
        style: TextStyle(
          fontSize: 16, // You can adjust the font size
          fontWeight: FontWeight.bold,
          color: Colors.white, // You can adjust the text color
        ),
      ),
    );
  }
}