import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hedieaty/screens/login_page.dart';

class LoginForm extends StatefulWidget {
  final void Function() onSubmit; // Callback for form submission
  final void Function() onTapCreateAccount;
  LoginForm({required this.onSubmit, required this.onTapCreateAccount});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox( //Wrap with SizedBox
    width: MediaQuery.of(context).size.width * 0.8, //80% of screen width
    child: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "Username",
                prefixIcon: Icon(Icons.person, color: christmasWhite), // Added icon color
                hintStyle: TextStyle(color: christmasWhite.withOpacity(0.7)), // Lighter hint text
                filled: true, // Fill the input field background
                fillColor: christmasGold.withOpacity(0.2), // Transparent background
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // More rounded corners
                  borderSide: BorderSide.none, // Remove default border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: christmasWhite), // White border on focus
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              obscureText: _obscureText, // Added obscureText property
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock, color: christmasWhite),
                hintStyle: TextStyle(color: christmasWhite.withOpacity(0.7)),
                filled: true,
                fillColor: christmasGold.withOpacity(0.2),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: christmasWhite),
                ),
                suffixIcon: IconButton( // Added suffixIcon for password visibility toggle
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: christmasWhite,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle login
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit();
                }
              },
              child: Text("Login",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: christmasRouge,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("OR",),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                // Handle create account
                widget.onTapCreateAccount,
              child: Text("Create an Account",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: christmasRouge,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
}
}
// Form Widget
// Widget _buildLoginForm() {
// }