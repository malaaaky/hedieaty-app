import 'package:flutter/material.dart';
import 'package:hedieaty/src/widgets/text_fields_widgets.dart';
import 'package:hedieaty/src/screens/authentication/view/signup_page.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late String username;
  late String password;
  
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
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            SizedBox(height: 15),
            buildPasswordField(_isPasswordHidden,
              _togglePasswordVisibility,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },),
            SizedBox(height: 20),
            buildActionButton(
              context,
              "Login",
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Handle login logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login successful!"),),
                  );
                  // Navigate to Home Screen
                  Navigator.pushReplacementNamed(context, '/home');
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
