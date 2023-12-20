import 'package:flutter/material.dart';
import 'package:untitled1/app_routes.dart';

import '../widgets/dynamic_button.dart';
import '../widgets/dynamic_input_container.dart';
import '../widgets/dynamic_link.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool obscureText = true;
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
                      height: 0,
                    ),
                  ),
                  SizedBox(height: 14,),
                  Text(
                    'Log in to your account for seamless access to the IoT Controlled Oxygen Concentrator App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(height: 24,),
                  buildDynamicInputContainer(
                    hintText: 'Username',
                  ),
                  SizedBox(height: 14,),
                  buildDynamicInputContainer(
                    hintText: 'Email',
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 14,),
                  Container(
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
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              // onChanged: (){},
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Color(0xFF070707),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14,),
                  Container(
                    decoration: ShapeDecoration(
                      // color: Color(0xDBD9D9D9),
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
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: obscureText,
                              // onChanged: (){},
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: InkWell(
                                  onTap: (){
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  child: Icon(
                                    obscureText ? Icons.visibility_off : Icons.visibility,
                                  ),
                                ),
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                  color: Color(0xFF070707),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14,),
                  DynamicButton(
                    text: 'Confirm',
                    onPressed: (){
                      Navigator.pushNamed(context, AppRoutes.emailVerificationPage);
                    },
                    dynamicTextColor: Colors.white,
                    dynamicColor: Color(0xFF3B82F6),
                  ),
                  SizedBox(height: 14,),
                  DynamicLink(
                    text: 'Already have an account? SignIn',
                    textAlign: TextAlign.center,
                    dynamicColor: Color(0xFF3B82F6),
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.signInPage);
                    },
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}