
import 'package:sqflite/sqflite.dart';

import 'user_model.dart';
import 'user_fields.dart';

class HedieatyUserDatabase {
  static final HedieatyUserDatabase instance = HedieatyUserDatabase._internal();

  static Database? _database;

  HedieatyUserDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/users.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
        CREATE TABLE ${UserFields.tableName} (
          ${UserFields.id} ${UserFields.idType},
          ${UserFields.name} ${UserFields.textType},
          ${UserFields.email} ${UserFields.textType},
          ${UserFields.preferences} ${UserFields.textType},
          ${UserFields.profilePicture} ${UserFields.textType}
        )
      ''');
  }

  Future<UserModel> create(UserModel user) async {
    final db = await instance.database;

    // Check if user already exists
    final existingUsers = await db.query(
      UserFields.tableName,
      where: 'id = ?',
      whereArgs: [user.id],
    );

    if (existingUsers.isEmpty) {
      // Insert only if no record exists
      final id = await db.insert(UserFields.tableName, user.toJson());
      return user.copy(id: id);
    } else {
      print('User with ID ${user.id} already exists. Skipping insert.');
      return user; // Or handle as per your requirements
    }
  }


  Future<UserModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      UserFields.tableName,
      columns: UserFields.values,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      UserFields.tableName,
      columns: UserFields.values,
      where: '${UserFields.email} = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<UserModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${UserFields.name} DESC';
    final result = await db.query(UserFields.tableName, orderBy: orderBy);
    return result.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<int> update(UserModel user) async {
    final db = await instance.database;
    return db.update(
      UserFields.tableName,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      UserFields.tableName,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
