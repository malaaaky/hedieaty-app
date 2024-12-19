class Friend {
  int? userId;
  int? friendId;
  String? friendName;
  String? friendEmail;
  String? friendPreferences;
  String? events; // List of events related to the friend (could be IDs or names)

  Friend({
    required this.userId,
    required this.friendId,
    this.friendName,
    this.friendEmail,
    this.friendPreferences,
    this.events,
  });

  // Copy method to create a new instance with possibly modified values
  Friend copy({
    int? userId,
    int? friendId,
    String? friendName,
    String? friendEmail,
    String? friendPreferences,
    String? events,
  }) {
    return Friend(
      userId: userId ?? this.userId,
      friendId: friendId ?? this.friendId,
      friendName: friendName ?? this.friendName,
      friendEmail: friendEmail ?? this.friendEmail,
      friendPreferences: friendPreferences ?? this.friendPreferences,
      events: events ?? this.events,
    );
  }

  // Method to convert a Friend object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'friendId': friendId,
      'friendName': friendName??'Unknown',
      'friendEmail': friendEmail??'',
      'friend_preferences': friendPreferences ?? '',
      'events': events?? 0,
    };
  }

  // Method to create a Friend object from JSON
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      userId: json['userId'] as int?,
      friendId: json['friendId'] as int,
      friendName: json['friendName'] as String?,  // Nullable
      friendEmail: json['friendEmail'] as String?, // Nullable
      friendPreferences: json['friend_preferences'] as String?,
      events: json['events'] as String, // Nullable
    );
  }
}