import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled1/app_routes.dart';
import 'package:untitled1/screens/home_page.dart';
import '../widgets1/dynamic_button.dart';
import '../widgets1/dynamic_input_container.dart';
import '../widgets1/dynamic_link.dart';
import 'package:http/http.dart' as http;

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool obscureText = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;
  String userId = "";

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
                  'Sign In',
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
                  hintText: 'Email',
                  inputType: TextInputType.emailAddress,
                  controller: usernameController,
                ),
                SizedBox(height: 14),
                buildPasswordTextField(),
                SizedBox(height: 14),
                DynamicLink(
                  text: 'Forgot Password ?',
                ),
                SizedBox(height: 14),
                DynamicButton(
                  text: 'Confirm',
                  onPressed: () async {
                    await _login(context);
                  },
                  dynamicTextColor: Colors.white,
                  dynamicColor: Color(0xFF3B82F6),
                ),
                SizedBox(height: 14),
                DynamicLink(
                  text: 'Don\'t have an account? Signup',
                  textAlign: TextAlign.center,
                  dynamicColor: Color(0xFF3B82F6),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.signUpPage);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordTextField() {
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
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    child: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Color(0xFF070707),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final String apiUrl =
        'http://udhyog4.in/API/login.php?email=${usernameController.text}&password=${passwordController.text}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            isLoggedIn = true;
            userId = data['userId'];
          });

          // Check if the user is a doctor
          if (data['role'] != 'doctor') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No such account registered. Please check your credentials.'),
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
            );
          }
        } else {
          // Check if the user is disabled
          if (data['status'] == 'error' && data['message'] == 'User is disabled.') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User is disabled. Please contact support.'),
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            // Show Snackbar for invalid username or password
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid username or password. Please try again.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } else {
        // Handle the error response
        // print('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Error: $error');
    }
  }
}
