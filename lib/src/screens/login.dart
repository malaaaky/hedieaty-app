import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/animated_image_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/src/screens/home_page.dart';
import 'package:hedieaty/src/screens/authentication/model/user_model.dart';
import 'package:hedieaty/src/screens/authentication/model/user_session.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController preferencesController = TextEditingController();
  bool isLogin = true;
  bool _isPasswordHidden = true;
  String? selectedProfilePicture; // Stores the selected profile picture path

  // List of predefined profile pictures
  final List<String> profilePictures = [
    'lib/assets/avatars/avatar2.jpg',
    'lib/assets/avatars/avatar3.webp',
    'lib/assets/avatars/avatar4.jpg',
  ];

  void toggleFormMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> authenticateUser() async {
    if (isLogin) {
      await loginUser();
    } else {
      await signUpUser();
    }
  }

  Future<void> loginUser() async {
    try {
      //firebase auth login
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
// fetch user from firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        final loggedInUser = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        UserSession.currentUserId = loggedInUser.id;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        showError('User data not found.');
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  Future<void> signUpUser() async {
    try {
      //firebase auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
// check if user has profile pic
      String profilePictureToSave =
          selectedProfilePicture ?? 'lib/assets/profiles/guest_pic.png';

      final user = UserModel(
        id: userCredential.user!.uid.hashCode,
        name: nameController.text,
        email: emailController.text,
        preferences: preferencesController.text,
        profilePicture: profilePictureToSave,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toJson());

      showSuccess('Account created successfully! You can now log in.');
      toggleFormMode();
    } catch (e) {
      showError(e.toString());
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget buildCustomTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    VoidCallback? onPasswordToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: onPasswordToggle != null
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: onPasswordToggle,
        )
            : null,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.red.withOpacity(0.2),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [christmasRed, christmasGold],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: topPadding),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: AnimatedImage(),
                ),
                const SizedBox(height: 20),
                Text(
                  isLogin ? 'Welcome Back!' : 'Create an Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: christmasRed,
                  ),
                ),
                const SizedBox(height: 20),
                if (!isLogin)
                  buildCustomTextField(
                    hintText: "Name",
                    icon: Icons.person,
                    controller: nameController,
                  ),
                const SizedBox(height: 10),
                buildCustomTextField(
                  hintText: "Email",
                  icon: Icons.email,
                  controller: emailController,
                ),
                const SizedBox(height: 10),
                buildCustomTextField(
                  hintText: "Password",
                  icon: Icons.lock,
                  controller: passwordController,
                  obscureText: _isPasswordHidden,
                  onPasswordToggle: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),
                const SizedBox(height: 10),
                if (!isLogin)
                  buildCustomTextField(
                    hintText: "Preferences",
                    icon: Icons.favorite,
                    controller: preferencesController,
                  ),
                const SizedBox(height: 10),
                if (!isLogin)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Avatar:',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: profilePictures.length,
                        itemBuilder: (context, index) {
                          final imagePath = profilePictures[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedProfilePicture = imagePath;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedProfilePicture == imagePath
                                      ? Colors.red
                                      : Colors.grey,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Image.asset(imagePath, fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: authenticateUser,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: christmasRouge,
                  ),
                  child: Text(
                    isLogin ? 'Login' : 'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      color: christmasWhite,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: toggleFormMode,
                  child: Text(
                    isLogin
                        ? 'Don’t have an account? Sign Up'
                        : 'Already have an account? Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: christmasRed,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
