// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:hedieaty/models/friend.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;
//
//   DatabaseHelper._internal();
//
//   static Database? _database;
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     final databasesPath = await getDatabasesPath();
//     final path = join(databasesPath, 'hedieaty.db');
//
//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDb,
//     );
//   }
//
//   Future<void> _createDb(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE friends (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL,
//         imagePath TEXT,
//         upcomingEvents INTEGER
//       )
//     ''');
//   }
//
//   Future<void> insertFriend(Friend friend) async {
//     final db = await database;
//     await db.insert(
//       'friends',
//       friend.toMap(), // You'll need to implement toMap() in the Friend model
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
// }