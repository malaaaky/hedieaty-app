class EventFields {
  static const String tableName = 'events';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT';
  static const String intType = 'INTEGER NOT NULL';

  static const String id = 'id';
  static const String name = 'name';
  static const String date = 'date';
  static const String location = 'location';
  static const String description = 'description';
  static const String userID = 'user_id';
  static const String docId = 'docId'; // Added docId field

  static const List<String> values = [
    id,
    name,
    date,
    location,
    description,
    userID,
    docId, // Added docId to the list of fields
  ];
}
