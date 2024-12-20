// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firestore with SQLite Cache',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: FirestoreCacheScreen(),
//     );
//   }
// }
//
//
// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;
//
//   DatabaseHelper._init();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('cache.db');
//     return _database!;
//   }
//
//   Future<Database> _initDB(String path) async {
//     final dbPath = await getDatabasesPath();
//     final dbLocation = join(dbPath, path);
//     return await openDatabase(dbLocation, version: 1, onCreate: _createDB);
//   }
//
//   Future _createDB(Database db, int version) async {
//     const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//     const textType = 'TEXT NOT NULL';
//     await db.execute('''
//     CREATE TABLE cache (
//       id $idType,
//       data $textType
//     )
//     ''');
//   }
//
//   Future<void> insertCacheData(String data) async {
//     final db = await instance.database;
//     await db.insert('cache', {'data': data});
//   }
//
//   Future<List<Map<String, dynamic>>> fetchCacheData() async {
//     final db = await instance.database;
//     return await db.query('cache');
//   }
// }
//
//
// class FirestoreCache {
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//
//   // Fetch data from Firestore
//   Future<List<Map<String, dynamic>>> fetchFirestoreData() async {
//     try {
//       QuerySnapshot snapshot =
//       await _firebaseFirestore.collection('items').get();
//       List<Map<String, dynamic>> firestoreData = snapshot.docs
//           .map((doc) => {'id': doc.id, 'data': doc.data()})
//           .toList();
//       return firestoreData;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<void> cacheFirestoreData(List<Map<String, dynamic>> data) async {
//     // Convert data into a string format for SQLite storage
//     String dataString = data.toString();
//     await DatabaseHelper.instance.insertCacheData(dataString);
//   }
//
//   // Fetch cached data from SQLite
//   Future<List<Map<String, dynamic>>> fetchCachedData() async {
//     return await DatabaseHelper.instance.fetchCacheData();
//   }
// }
//
//
// class FirestoreCacheScreen extends StatefulWidget {
//   @override
//   _FirestoreCacheScreenState createState() => _FirestoreCacheScreenState();
// }
//
// class _FirestoreCacheScreenState extends State<FirestoreCacheScreen> {
//   final FirestoreCache _firestoreCache = FirestoreCache();
//   bool _isLoading = true;
//   List<Map<String, dynamic>> _data = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   _loadData() async {
//     try {
// // First, try to fetch data from Firestore
//       List<Map<String, dynamic>> firestoreData =
//       await _firestoreCache.fetchFirestoreData();
//
// // Cache it into SQLite
//       await _firestoreCache.cacheFirestoreData(firestoreData);
//
// // Update the UI with the Firestore data
//       setState(() {
//         _data = firestoreData;
//         _isLoading = false;
//       });
//     } catch (e) {
// // If Firestore fails, fall back to SQLite cache
//       List<Map<String, dynamic>> cachedData =
//       await _firestoreCache.fetchCachedData();
//       setState(() {
//         _data = cachedData;
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Firestore with SQLite Cache')),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: _data.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Item ${_data[index]['id']}'),
//             subtitle: Text(_data[index]['data'].toString()),
//           );
//         },
//       ),
//     );
//   }
// }
