import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:hedieaty/src/widgets/text_fields_widgets.dart';
import 'package:hedieaty/src/screens/authentication/view/login_page.dart';

import 'dart:async';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  Future<void> signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_profileImage != null) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          // Clear form fields and reset profile image
          _formKey.currentState!.reset();
          _emailController.clear();
          _passwordController.clear();
          _nameController.clear();
          setState(() {
            _profileImage = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Sign up successful!"),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to login or home screen after successful sign up
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } on FirebaseAuthException catch (e) {
          String errorMessage;
          switch (e.code) {
            case 'email-already-in-use':
              errorMessage = "This email is already registered.";
              break;
            case 'weak-password':
              errorMessage = "The password is too weak.";
              break;
            case 'invalid-email':
              errorMessage = "The email address is invalid.";
              break;
            default:
              errorMessage = "An error occurred. Please try again.";
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
         } catch (e) {
          // debugging purpose
          print('Unexpected error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("An unexpected error occurred: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please pick an image first"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all required fields"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Picture Placeholder and Upload Button
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? Icon(Icons.person, size: 55, color: Colors.grey[400])
                        : null,
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.grey[700]),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildTextFieldController(
                controller: _nameController,
                hintText: "Username",
                icon: Icons.person,
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Please enter a username'
                    : null,
              ),
              SizedBox(height: 15),
              buildTextFieldController(
                controller: _emailController,
                hintText: "Email",
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              buildPasswordFieldController(
                _isPasswordHidden,
                _togglePasswordVisibility,
                controller: _passwordController,
              ),
              SizedBox(height: 20),
              buildActionButton(
                context,
                "Sign Up",
                onPressed: () {
                  signUp();
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
