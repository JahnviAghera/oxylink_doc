import 'package:flutter/material.dart';
import 'package:untitled1/app_routes.dart';

import '../widgets/dynamic_button.dart';
import '../widgets/dynamic_input_container.dart';
import '../widgets/dynamic_link.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Row(
                children: [
                  InkWell(
                    child: Icon(Icons.arrow_back_ios),
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.signInPage);
                    },
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Email Verification',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 59),
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'To continue, enter code we just sent to\n',
                      style: TextStyle(
                        color: Color(0xFF656565),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: 'jsmith.mobbin1@gmail.com',
                      style: TextStyle(
                        color: Color(0xFF070707),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '.  ',
                      style: TextStyle(
                        color: Color(0xFF656565),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 311,
                child: buildDynamicInputContainer(
                    hintText: 'Email Code'
                ),
              ),
            ),
            SizedBox(height: 14),
            Center(
              child: Container(
                width: 311,
                child: DynamicButton(
                  text: 'Continue',
                  onPressed: (){},
                  dynamicTextColor: Colors.white,
                  dynamicColor: Color(0xFF3B82F6),
                )
              ),
            ),
            SizedBox(height: 22),
            Center(
              child: Container(
                width: 311,
                child: DynamicLink(
                    text: 'Didn’t get code? Try Again',
                  textAlign: TextAlign.center,
                  dynamicColor: Color(0xFF3B82F6),
               ),
              )
            )
          ],
        )
        )
      ),
    );
  }
}