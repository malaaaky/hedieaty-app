class UserFields {
  static const String tableName = 'users';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT';
  static const String intType = 'INTEGER NOT NULL';
  static const String id = 'id';
  static const String name = 'name';
  static const String email = 'email';
  static const String preferences = 'preferences';
  static const String profilePicture = 'profilePicture';

  static const List<String> values = [
    id,
    name,
    email,
    preferences,
    profilePicture,
  ];
}
