// import 'package:firebase_auth/firebase_auth.dart'as firebaseAuth;
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:hedieaty/models/user.dart';
//
// class AuthenticationService {
//   final firebaseAuth.FirebaseAuth _auth = firebaseAuth.FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   // Email/Password sign-in, sign-up, and sign-out methods...
//   // ... (Implementation omitted for brevity, but you'll need these)
//
//   // Google Sign-In
//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
//       final credential = firebaseAuth.GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       final firebaseAuth.UserCredential userCredential = await _auth.signInWithCredential(credential);
//       return _userFromFirebase(userCredential.user);
//     } catch (e) {
//       print('Google sign in failed: $e');
//       return null;
//     }
//   }
//
//   //Helper method to convert FirebaseUser to User object
//   User? _userFromFirebase(firebaseAuth.User? user){
//     if (user == null) return null;
//     return User(
//         uid: user.uid,
//         name: user.displayName ?? "", // Handle cases where displayName is null
//         email: user.email ?? "", // Handle cases where email is null
//         isLoggedIn: true
//     );
//   }
//
// // ... other authentication methods (sign-out, etc.)
// }