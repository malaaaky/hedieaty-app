import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hedieaty/widgets/login_from_widget.dart';
import'package:hedieaty/utils/constants.dart';

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

class AnimatedImage extends StatefulWidget {
  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(0, 0.08),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 5, // Adjusted vertical position to create space
          right:50,
          child: Image.asset(
            'lib/assets/ballons_login_page.png',
            width: 300, // Set your desired width
            height: 150, // Set your desired height,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 120, // Adjusted vertical position to create space
          left: 75,   // Adjusted horizontal position
          child: SlideTransition(
            position: _animation,
            child: Image.asset(
              'lib/assets/gift_login_img.png',
              width: 200, // Set your desired width
              height: 200, // Set your desired height,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}