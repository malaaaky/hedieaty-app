import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hedieaty/src/screens/authentication/model/user_session.dart';
import 'firebase_options.dart';

import 'package:hedieaty/src/screens/gifts/view/gift_list_page.dart';
import 'package:hedieaty/src/screens/authentication/view/login_page.dart'; // Import your login page
import 'package:hedieaty/src/screens/authentication/view/signup_page.dart';
import 'package:hedieaty/src/screens/events/view/event_list_page.dart';
import 'package:hedieaty/src/screens/profile_page.dart';
import 'package:hedieaty/src/screens/home_page.dart';

import 'src/screens/login.dart';


Future<void> main() async{
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log only the main error
    debugPrint(details.exceptionAsString());
    // Optionally, print the stack trace if needed
    // debugPrint(details.stack.toString());
  };

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoginSignupPage(),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'Hedieaty',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     initialRoute: '/login',
  //     routes: {
  //       '/login':(context)=> LoginScreen(),
  //       '/signup':(context)=> SignUpScreen(),
  //       '/home': (context) => HomePage(),
  //       '/events': (context) => EventListPage(userID: UserSession.currentUserId!.toInt(), userName: "My Events"),
  //       // '/gifts': (context) => GiftListPage(),
  //       '/profile': (context) => ProfilePage(userId: UserSession.currentUserId!.toInt()),
  //
  //     },
  //     home: LoginScreen(), // Set your login page as the home screen
  //   );
  // }
}