import 'package:employee_manager/guest/onboarding_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Corrected constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(), // Set LoginPage as the home
      debugShowCheckedModeBanner: false,
    );
  }
}
