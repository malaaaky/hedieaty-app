import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:hedieaty/src/widgets/text_fields_widgets.dart';
import 'package:hedieaty/src/screens/authentication/view/login_page.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late String name;
  late String email;
  late String password;

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
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
              buildTextField(
                hintText: "Username",
                icon: Icons.person,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a username' : null,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
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
                onChanged: (value) {
                  setState(() {
                    email = value;
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
                "Sign Up",
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // TODO: Handle sign up logic
                    print('Name: $name');
                    print('Email: $email');
                    print('Password: $password');
                    if (_profileImage != null) {
                      print('Profile Image Path: ${_profileImage!.path}');
                    } else {
                      print('No profile image selected.');
                    }
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
