import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6495ED),
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Path gambar logo
          width: 175,
          height: 175,
        ),
      ),
    );
  }
}
