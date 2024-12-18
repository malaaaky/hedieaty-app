import 'package:flutter/material.dart';
import 'package:hedieaty/screens//login_page.dart'; // Import your login page

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log only the main error
    debugPrint(details.exceptionAsString());
    // Optionally, print the stack trace if needed
    // debugPrint(details.stack.toString());
  };
  runApp(HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Set your login page as the home screen
    );
  }
}