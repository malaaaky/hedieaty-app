import 'package:flutter/foundation.dart';

class User {
  final String? uid; // Firebase UID (can be null if not yet authenticated)
  final String name;
  final String email;
  final bool isLoggedIn;

  User({
    this.uid,
    required this.name,
    required this.email,
    required this.isLoggedIn,
  });


  //Optional: Add a copyWith method for easier updates
  User copyWith({String? uid, String? name, String? email, bool? isLoggedIn}) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  //Optional: Override toString() for easier debugging
  @override
  String toString() {
    return 'User{uid: $uid, name: $name, email: $email, isLoggedIn: $isLoggedIn}';
  }

  //Optional: Override == and hashCode for proper equality checks
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              name == other.name &&
              email == other.email &&
              isLoggedIn == other.isLoggedIn;

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ email.hashCode ^ isLoggedIn.hashCode;
}