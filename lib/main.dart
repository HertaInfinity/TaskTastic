import 'package:flutter/material.dart';
import './screens/splash_screen.dart';
import './screens/home.dart';

// Entry point of the Flutter app
void main() {
  runApp(const MyApp());
}

// Main Application Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner from UI
      title: 'TaskTastic', // Title of the app
      theme: ThemeData( // Applying a theme for UI consistency
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Default background
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      initialRoute: '/', // First screen to show
      routes: {
        '/': (context) => SplashScreen(), // Displays splash screen first
        '/home': (context) => Home(), // Navigates to home screen
      },
    );
  }
}