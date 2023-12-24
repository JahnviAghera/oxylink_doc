import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:quiver/async.dart';
import 'package:untitled1/app_routes.dart';
import '../widgets/dynamic_button.dart';
import '../widgets/dynamic_input_container.dart';
import '../widgets/dynamic_link.dart';
import 'package:http/http.dart' as http;

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late Timer timer;
  late int countdown;
  late String verificationCode;

  @override
  void initState() {
    super.initState();
    countdown = 10; // Set the initial countdown value
    generateVerificationCode();
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: countdown),
      new Duration(seconds: 10),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        countdown = countdown - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  void generateVerificationCode() {
    final random = Random();
    verificationCode = (100000 + random.nextInt(900000)).toString();
    startTimer();
    sendEmail(widget.email, 'OTP Verification', verificationCode);
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  static Future<void> sendEmail(String toEmail, String subject, String body) async {
    final smtpServer = gmail('jahnviaghera@gmail.com', 'mory zjsw ndsd akod');
    final message = Message()
      ..from = Address('jahnviaghera@gmail.com', 'Your Name')
      ..recipients.add(toEmail)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.messageSendingEnd}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  TextEditingController codeController = TextEditingController();

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
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.signInPage);
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
                        text: widget.email,
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
                    hintText: 'Email Code',
                    controller: codeController,
                  ),
                ),
              ),
              SizedBox(height: 14),
              Center(
                child: Container(
                  width: 311,
                  child: DynamicButton(
                    text: 'Continue',
                    onPressed: () {
                      if (codeController.text == verificationCode) {
                        Navigator.pushNamed(context, AppRoutes.signInPage);
                      }
                    },
                    dynamicTextColor: Colors.white,
                    dynamicColor: Color(0xFF3B82F6),
                  ),
                ),
              ),
              SizedBox(height: 22),
              Center(
                child: Container(
                  width: 311,
                  child: DynamicLink(
                    onTap: () {
                      if (countdown == 0) {
                        generateVerificationCode();
                      }
                    },
                    text: 'Resend Code in $countdown s', // Show the countdown
                    textAlign: TextAlign.center,
                    dynamicColor: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
