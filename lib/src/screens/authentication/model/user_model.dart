class UserModel {
  String? uid;
  String? name;
  String? email;
  String? profileImage;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.profileImage,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImage,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        profileImage: profileImage ?? this.profileImage,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'] as String?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    profileImage: json['profileimage'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'profileimage': profileImage,
  };
}
