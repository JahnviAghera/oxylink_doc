import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:untitled1/app_routes.dart';
import 'package:untitled1/screens/email_verification_page.dart';
import 'package:untitled1/widgets1/dynamic_button.dart';
import 'package:untitled1/widgets1/dynamic_input_container.dart';
import 'package:untitled1/widgets1/dynamic_link.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool obscureText = true;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 34.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'Log in to your account for seamless access to the IoT Controlled Oxygen Concentrator App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 24),
                buildDynamicInputContainer(
                  controller: usernameController,
                  hintText: 'Username',
                ),
                SizedBox(height: 14),
                buildDynamicInputContainer(
                  hintText: 'Email',
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 14),
                buildPasswordTextField(
                  controller: passwordController,
                  labelText: 'Password',
                ),
                SizedBox(height: 14),
                buildPasswordTextField(
                  controller: confirmPasswordController,
                  labelText: 'Confirm Password',
                  isConfirm: true,
                  obscureText: obscureText,
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
                SizedBox(height: 14),
                DynamicButton(
                  text: 'Confirm',
                  onPressed: () async {
                    await handleSignUp();
                  },
                  dynamicTextColor: Colors.white,
                  dynamicColor: Color(0xFF3B82F6),
                ),
                SizedBox(height: 14),
                DynamicLink(
                  text: 'Already have an account? SignIn',
                  textAlign: TextAlign.center,
                  dynamicColor: Color(0xFF3B82F6),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.signInPage);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordTextField({
    required TextEditingController controller,
    required String labelText,
    bool isConfirm = false,
    bool obscureText = true,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: TextStyle(
                    color: Color(0xFF070707),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(),
                  suffixIcon: isConfirm
                      ? InkWell(
                    onTap: onTap,
                    child: Icon(
                      obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> handleSignUp() async {
    try {
      final String apiUrl = 'http://udhyog4.in/API/register.php';
      final String fullname = usernameController.text;
      final String username = fullname.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
      final String email = emailController.text;
      final String password = passwordController.text;
      final String confirmpassword = confirmPasswordController.text;

      if (confirmpassword == password) {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'full_name': fullname,
            // 'username': username,
            'email': email,
            'password': password,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          print('Response: $data');

          if (data['status'] == 'success') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EmailVerificationPage(email: email)),
            );
          } else {
            // Handle registration error
            print('Registration failed. Server message: ${data['message']}');
            if(data['message'].toLowerCase().contains('duplicate')){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account Already Exists'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          }
        } else {
          // Handle HTTP request error
          print('Failed to register. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error: $e');
      // Handle errors and show user-friendly messages...
    }
  }
}
