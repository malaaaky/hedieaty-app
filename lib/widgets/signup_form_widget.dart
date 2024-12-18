import 'package:flutter/material.dart';
import 'package:hedieaty/widgets/text_fields_widgets.dart';
import 'package:hedieaty/screens/login_page.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(
                hintText: "Username",
                icon: Icons.person,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a username' : null,
              ),
              SizedBox(height: 15),
              buildTextField(
                hintText: "Email",
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(
                      value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              buildPasswordField(_isPasswordHidden, _togglePasswordVisibility),
              SizedBox(height: 20),
              buildActionButton(
                context,
                "Sign Up",
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // TODO: Handle sign up logic
                  }
                },
              ),
              SizedBox(height: 10),
              buildOrDivider(),
              SizedBox(height: 10),
              buildActionButton(
                context,
                "Already have an account?",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
