
import 'package:hedieaty/src/screens/authentication/model/user_fields.dart';


class UserModel {
  int? id;
  String? name;
  String? email;
  String? preferences;
  String? profilePicture; // New field for profile picture path

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.preferences,
    this.profilePicture,
  });

  UserModel copy({
    int? id,
    String? name,
    String? email,
    String? preferences,
    String? profilePicture,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        preferences: preferences ?? this.preferences,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  Map<String, Object?> toJson() => {
    UserFields.id: id,
    UserFields.name: name,
    UserFields.email: email,
    UserFields.preferences: preferences,
    UserFields.profilePicture: profilePicture,
  };

  factory UserModel.fromJson(Map<String, Object?> json) => UserModel(
    id: json[UserFields.id] as int?,
    name: json[UserFields.name] as String?,
    email: json[UserFields.email] as String?,
    preferences: json[UserFields.preferences] as String?,
    profilePicture: json[UserFields.profilePicture] as String?,
  );
}
