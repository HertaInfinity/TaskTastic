import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Fade animation setup
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Reduced duration for a quicker splash screen
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Move to home screen after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home'); // Navigates to home
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Properly dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color of splash screen
      body: Center(
        child: FadeTransition(
          opacity: _animation, // Applies fade-in effect
          child: Image.asset(
            'assets/logo.png', // Make sure this file exists in the assets folder
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}