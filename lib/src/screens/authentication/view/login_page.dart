import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hedieaty/src/widgets/login_from_widget.dart';
import'package:hedieaty/src/utils/constants.dart';
import 'package:hedieaty/src/widgets/animated_image_widget.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [christmasRed, christmasGold], // Christmas Gradient
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: topPadding),
                    SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: availableHeight * 0.4,
                      ),
                      child: AnimatedImage(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Hi User",
                      style: TextStyle(
                        color: christmasWhite, // White text
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Let's Get Started",
                      style: TextStyle(color: christmasWhite, fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    LoginForm(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
