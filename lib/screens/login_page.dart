import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hedieaty/widgets/login_from_widget.dart';
import 'package:hedieaty/widgets/signup_form_widget.dart';

// Christmas Theme Colors
final christmasGreen = Color(0xFF034F1B);
final christmasGold = Color(0xFFE6dCb1);
final christmasWhite = Colors.white;
final christmasYellow = Color(0xFFceac5c);
final christmasLightRed = Color(0xFFbd3634);
final christmasRed = Color(0xFF7e121d);
final christmasRouge = Color(0xFFad132d);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLoginForm = true; // Manage form visibility
  bool showWelcomeMessage = false; // Manage welcome message visibility
  final _formKey = GlobalKey<FormState>(); //Added GlobalKey to Form

  void _toggleForms() {
    setState(() {
      showLoginForm = !showLoginForm;
    });
  }


  void _submitLoginForm() {
    //Handle login form submission - Add your actual login logic here
    if (_formKey.currentState!.validate()) {
      //Do something
    }
  }

  void _submitSignupForm() {
    //Handle signup form submission - Add your actual signup logic here
    if (_formKey.currentState!.validate()) {
      //Do something
    }
  }
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
              child: Stack( // Use Stack for overlay
                children: [
                  SizedBox(
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
                            color: christmasWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Let's Get Started",
                          style:
                          TextStyle(color: christmasWhite, fontSize: 18),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  AnimatedPositioned(
                    bottom: showLoginForm ? 0 : -MediaQuery.of(context).size.height,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: showLoginForm
                            ? LoginForm(
                          onSubmit: _submitLoginForm,
                          onTapCreateAccount: _toggleForms, // Pass the function
                        )
                            : SignupForm(onSubmit: _submitSignupForm),
                      ),
                    ),
                  ),
                  if(showWelcomeMessage) //Show welcome message
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Welcome! You're successfully logged in.", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    )
                ],
              ),
            );
          },
        ),
      )
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
