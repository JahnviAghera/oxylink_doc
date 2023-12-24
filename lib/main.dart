import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:untitled1/screens/email_verification_page.dart';
import 'package:untitled1/screens/sign_in_page.dart';
import 'package:untitled1/screens/sign_up_page.dart';
import 'package:untitled1/screens/splash_screen.dart';

import 'app_routes.dart'; // Import the services library

Future main() async {
  runApp(const MyApp());
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '107.180.34.197',
      port: 3306,
      user: 'Udhyog_Gold',
      db: 'oxy_link',
      password: 'U4@2019'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Make the status bar transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // You can change the icon color here
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splashScreen,
      routes: {
        AppRoutes.splashScreen: (context) => const SplashScreen(),
        AppRoutes.signInPage: (context) => const SignInPage(),
        AppRoutes.signUpPage: (context) => const SignUpPage(),
      },
      home: const SplashScreen(),
    );
  }
}




