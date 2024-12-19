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
    'id': id,
    'name': name,
    'email': email,
    'preferences': preferences,
    'profilePicture': profilePicture,
  };

  factory UserModel.fromJson(Map<String, Object?> json) => UserModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    preferences: json['preferences'] as String?,
    profilePicture: json['profilePicture'] as String?,
  );
}
