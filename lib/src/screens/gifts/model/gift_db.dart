import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'gift_fields.dart';
import 'gift_model.dart';

import 'package:hedieaty/src/screens/events/model/event_fields.dart';
import 'package:hedieaty/src/screens/events/model/event_model.dart';

import 'package:hedieaty/src/screens/authentication/model/user_session.dart';

import 'package:hedieaty/src/screens/friends/model/friend_model.dart';
import 'package:hedieaty/src/screens/friends/model/friend_fields.dart';


class HedieatyDatabase {
  static final HedieatyDatabase instance = HedieatyDatabase._internal();

  static Database? _database;

  HedieatyDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/gifts.db';
    return await openDatabase(
      path,
      version: 2, // Increment the database version
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
        CREATE TABLE ${GiftFields.tableName} (
          ${GiftFields.id} ${GiftFields.idType},
          ${GiftFields.name} ${GiftFields.textType},
          ${GiftFields.description} ${GiftFields.textType},
          ${GiftFields.category} ${GiftFields.textType},
          ${GiftFields.price} ${GiftFields.textType},
          ${GiftFields.eventID} ${GiftFields.textType},
          ${GiftFields.status} ${GiftFields.boolType},
          ${GiftFields.docId} ${GiftFields.textType},
          userID INTEGER
        )
      ''');
    await db.execute('''
        CREATE TABLE ${EventFields.tableName} (
          ${EventFields.id} ${EventFields.idType},
          ${EventFields.name} ${EventFields.textType},
          ${EventFields.date} ${EventFields.textType},
          ${EventFields.location} ${EventFields.textType},
          ${EventFields.docId} TEXT, 
          ${EventFields.description} ${EventFields.textType},
          ${EventFields.userID} ${EventFields.intType}
        )
      ''');
    db.execute('''
        CREATE TABLE ${FriendFields.tableName} (
          ${FriendFields.userId} ${FriendFields.intType},
          ${FriendFields.friendId} ${FriendFields.idType},
          ${FriendFields.friendName} ${FriendFields.textType},
          ${FriendFields.friendEmail} ${FriendFields.textType},
          ${FriendFields.friendPreferences} ${FriendFields.textType},
          ${FriendFields.events} ${FriendFields.intType})
      ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE ${GiftFields.tableName} ADD COLUMN userID INTEGER');
    }
  }

  Future<GiftModel> createGift(GiftModel gift) async {
    final db = await instance.database;

    // Ensure `userID` is being set
    final updatedGift = gift.copy(userID: UserSession.currentUserId);

    // Check if the gift already exists
    final existingGift = await db.query(
      GiftFields.tableName,
      where: '${GiftFields.id} = ?',
      whereArgs: [gift.id],
    );

    if (existingGift.isNotEmpty) {
      // Update the existing gift
      await db.update(
        GiftFields.tableName,
        updatedGift.toJson(),
        where: '${GiftFields.id} = ?',
        whereArgs: [gift.id],
      );
      return updatedGift;
    }

    // Insert a new gift with `userID`
    final id = await db.insert(GiftFields.tableName, updatedGift.toJson());
    return updatedGift.copy(id: id);
  }


  Future<GiftModel> readGiftById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      GiftFields.tableName,
      columns: GiftFields.values,
      where: '${GiftFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return GiftModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<GiftModel>> readAllGifts() async {
    final db = await instance.database;
    const orderBy = '${GiftFields.name} DESC';
    final result = await db.query(GiftFields.tableName, orderBy: orderBy);
    return result.map((json) => GiftModel.fromJson(json)).toList();
  }

  Future<List<GiftModel>> readGiftsByUserId(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      GiftFields.tableName,
      where: 'userID = ?',
      whereArgs: [userId],
    );
    return result.map((json) => GiftModel.fromJson(json)).toList();
  }

  Future<int> updateGift(GiftModel gift) async {
    final db = await instance.database;
    return db.update(
      GiftFields.tableName,
      gift.toJson(),
      where: '${GiftFields.id} = ?',
      whereArgs: [gift.id],
    );
  }

  Future<int> deleteGift(int id) async {
    final db = await instance.database;
    return await db.delete(
      GiftFields.tableName,
      where: '${GiftFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<EventModel> createEvent(EventModel event) async {
    final db = await instance.database;
    await db.insert(EventFields.tableName, event.toJson());
    return event;
  }

  Future<EventModel> readEventById(int eventId) async {
    final db = await instance.database;
    final maps = await db.query(
        EventFields.tableName,
        columns: EventFields.values,
        where: '${EventFields.id} = $eventId'
    );

    if (maps.isNotEmpty) {
      return EventModel.fromJson(maps.first);
    } else {
      throw Exception('ID $eventId not found');
    }
  }

  Future<List<EventModel>> readAllEvents() async {
    final db = await instance.database;
    final result = await db.query(EventFields.tableName);
    return result.map((json) => EventModel.fromJson(json)).toList();
  }

  Future<List<EventModel>> readAllEventsByFriendId(int friendId) async {
    final db = await instance.database;
    final result = await db.query(EventFields.tableName,
        where: '${EventFields.userID} = $friendId');
    return result.map((json) => EventModel.fromJson(json)).toList();
  }

  Future<int> updateEvent(EventModel event) async {
    final db = await instance.database;
    return db.update(
      EventFields.tableName,
      event.toJson(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEventById(int id) async {
    final db = await instance.database;
    return await db.delete(
      EventFields.tableName,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );
  }
  Future<Friend> createFriend(Friend friend) async {
    final db = await instance.database;
    await db.insert(FriendFields.tableName, friend.toJson());
    return friend;
  }
  Future<Friend> readFriendById(int friendId) async {
    final db = await instance.database;
    final maps = await db.query(
        FriendFields.tableName,
        columns: FriendFields.values,
        where: '${FriendFields.friendId} = $friendId'
    );

    if (maps.isNotEmpty) {
      return Friend.fromJson(maps.first);
    } else {
      throw Exception('ID $friendId not found');
    }
  }

  Future<List<Friend>> readAllFriendsByUserId() async {
    final db = await instance.database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final maps = await db.query(
      FriendFields.tableName,
      columns: FriendFields.values,
      where: '${FriendFields.userId} = ${prefs.getInt("ID")}',
      //  whereArgs: [FriendFields.userId],
    );


    return maps.map((json) => Friend.fromJson(json)).toList();
  }

  Future<int> deleteFriend(int userId, int friendId) async {
    final db = await instance.database;
    return await db.delete(
      FriendFields.tableName,
      where: '${FriendFields.userId} = ? AND ${FriendFields.friendId} = ?',
      whereArgs: [userId, friendId],
    );
  }


// Future close() async {
//   final db = await instance.database;
//   db.close();
// }
}
