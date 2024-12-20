import 'package:sqflite/sqflite.dart';

import 'event_fields.dart';
import 'event_model.dart';

class HedieatyEventDatabase {
  static final HedieatyEventDatabase instance =
  HedieatyEventDatabase._internal();

  static Database? _database;

  HedieatyEventDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/events.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
         CREATE TABLE ${EventFields.tableName} (
           ${EventFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
           ${EventFields.name} TEXT,
           ${EventFields.date} TEXT,
           ${EventFields.location} TEXT,
           ${EventFields.docId} TEXT, -- Add this column
           ${EventFields.description} TEXT,
           ${EventFields.userID} INTEGER NOT NULL
           )
        ''');

  }

  Future<EventModel> create(EventModel event) async {
    final db = await instance.database;

    // Check if the id already exists
    final existingEvent = await db.query(
      EventFields.tableName,
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );

    if (existingEvent.isNotEmpty) {
      throw Exception('Event with ID ${event.id} already exists.');
    }

    // Insert the new event
    await db.insert(EventFields.tableName, event.toJson());
    return event;
  }

  Future<EventModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      EventFields.tableName,
      columns: EventFields.values,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return EventModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<EventModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${EventFields.name} DESC';
    final result = await db.query(EventFields.tableName, orderBy: orderBy);
    return result.map((json) => EventModel.fromJson(json)).toList();
  }

  Future<List<EventModel>> readAllForFriend(int friendId) async {
    final db = await instance.database;

    const orderBy = '${EventFields.name} DESC';
    final result = await db.query(EventFields.tableName,
        where: '${EventFields.id} = $friendId');
    return result.map((json) => EventModel.fromJson(json)).toList();
  }

  Future<int> update(EventModel event) async {
    final db = await instance.database;
    return db.update(
      EventFields.tableName,
      event.toJson(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      EventFields.tableName,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
