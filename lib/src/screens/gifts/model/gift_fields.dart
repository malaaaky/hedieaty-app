class GiftFields {
  static const String tableName = 'gifts';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT';
  static const String intType = 'INTEGER NOT NULL';
  static const String boolType = 'BOOLEAN NOT NULL';

  static const String id = 'id';
  static const String name = 'name';
  static const String category = 'category';
  static const String description = 'description';
  static const String price = 'price';
  static const String status = 'status';
  static const String eventID = 'event_iD';
  static const String docId = 'docId'; // Added docId field


  static const List<String> values = [
    id,
    name,
    category,
    description,
    price,
    status,
    eventID,
    docId,
    // Added docId to the list of fields
  ];
}
