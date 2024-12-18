import 'package:flutter/material.dart';
import 'package:hedieaty/widgets/text_fields_widgets.dart';
import 'package:hedieaty/screens/signup_page.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildTextField(
              hintText: "Username",
              icon: Icons.person,
              validator: (value) =>
              value == null || value.isEmpty ? 'Please enter your username' : null,
            ),
            SizedBox(height: 15),
            buildPasswordField(_isPasswordHidden, _togglePasswordVisibility),
            SizedBox(height: 20),
            buildActionButton(
              context,
              "Login",
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Handle login logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login successful!")),
                  );
                }
              },
            ),
            SizedBox(height: 10),
            buildOrDivider(),
            SizedBox(height: 10),
            buildActionButton(
              context,
              "Create an Account",
              onPressed: () {
                // Navigate to the SignupPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }


}
