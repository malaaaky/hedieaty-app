class FriendFields {
  static const String tableName = 'friends';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String intType = 'INTEGER NOT NULL';
  static const String textType = 'TEXT NOT NULL';
  static const String userId = 'user_id';
  static const String friendId = 'friend_id';
  static const String friendName = 'friend_name';
  static const String friendEmail = 'friend_email';
  static const String friendPreferences = 'friend_preferences';
  static const String events = 'events';

  // Columns to be used in the database
  static const List<String> values = [
    userId,
    friendId,
    friendName,
    friendEmail,
    friendPreferences,
    events,
  ];
}
