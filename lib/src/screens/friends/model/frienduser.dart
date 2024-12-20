class FriendUser {
  int user_id;
  int friend_id;
  FriendUser({this.user_id = 0, this.friend_id = 0});

  factory FriendUser.fromJson(Map<String, Object?> json) => FriendUser(
    user_id: json['user_id'] as int,
    friend_id: json['friend_id'] as int,
  );

  Map<String, Object?> toJson() => {
    'user_id': user_id,
    'friend_id': friend_id,
  };
}