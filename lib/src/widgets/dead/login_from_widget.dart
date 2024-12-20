// import 'package:flutter/material.dart';
// import 'package:hedieaty/src/screens/home_page.dart';
// import 'package:hedieaty/src/widgets/dead/text_fields_widgets.dart';
// import 'package:hedieaty/src/screens/authentication/view/signup_page.dart';
// import '../../screens/authentication/model/user_session.dart';
// import '../../utils/constants.dart';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
//
// class LoginForm extends StatefulWidget {
//   @override
//   _LoginFormState createState() => _LoginFormState();
// }
//
// class _LoginFormState extends State<LoginForm> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//   bool _isPasswordHidden = true;
//   bool processing = false;
//
//   void _togglePasswordVisibility() {
//     setState(() {
//       _isPasswordHidden = !_isPasswordHidden;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             buildTextFieldController(
//               controller: _emailController,
//               hintText: "Email",
//               icon: Icons.email,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter an email';
//                 }
//                 if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                     .hasMatch(value)) {
//                   return 'Please enter a valid email';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 15),
//             buildPasswordFieldController(
//               _isPasswordHidden,
//               _togglePasswordVisibility,
//               controller: _passwordController,
//             ),
//             SizedBox(height: 10),
//             TextButton(
//                 onPressed: () {},
//                 child: const Text(
//                   'Forget Password ?',
//                   style: TextStyle(
//                       fontSize: 18, fontStyle: FontStyle.italic),
//                 )),
//             SizedBox(height: 20),
//             processing == true
//                 ? CircularProgressIndicator(
//               color: christmasGreen,
//             ) :
//             buildActionButton(
//               context,
//               "Login",
//               onPressed: () {
//                 login();
//               },
//             ),
//             SizedBox(height: 10),
//             buildOrDivider(),
//             SizedBox(height: 10),
//             buildActionButton(
//               context,
//               "Create an Account",
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => SignUpScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> login() async {
//     setState(() {
//       processing = true;
//     });
//     //check validation
//     if (_formKey.currentState?.validate() ?? false) {
//       //firebase create user
//       try {
//     final authResult=await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//         final uid = authResult.user?.uid;
//         if (uid != null) {
//           final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
//           if (userDoc.exists) {
//             final userData = userDoc.data()!;
//             UserSession.setCurrentUser(
//               id: userData['id'] as int,
//               email: userData['email'] as String?,
//               name: userData['name'] as String?,
//             );
//           }
//         }
//
//         // Clear form fields and reset profile image
//         _formKey.currentState!.reset();
//         _passwordController.clear();
//         _emailController.clear();
//         //snack bar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Login successful!"),
//             backgroundColor: Colors.green,
//           ),
//         );
//         // Navigate to login or home screen after successful sign up
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//         //exception handling
//       } on FirebaseAuthException catch (e) {
//         String errorMessage;
//         print("Error code: ${e.code}");
//         switch (e.code) {
//           case 'user-not-found':
//             errorMessage = "No user found for that email.";
//             break;
//           case 'invalid-credential':
//             errorMessage = "Wrong email/password provided for that user.";
//             break;
//           default:
//             errorMessage = "An error occurred. Please try again.";
//         }
//         setState(() {
//           processing = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMessage),
//             backgroundColor: Colors.red,
//           ),
//         );
//         // debugging purpose
//       } catch (e) {
//         print('Unexpected error: $e');
//         setState(() {
//           processing = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("An unexpected error occurred: $e"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//       //failed case
//     } else {
//       setState(() {
//         processing = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Please fill all required fields"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }