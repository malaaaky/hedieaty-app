// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:hedieaty/src/screens/friends/model/friend_model.dart';
// import 'package:hedieaty/src/screens/authentication/model/user_model.dart';
// import 'package:hedieaty/src/screens/authentication/model/user_session.dart';
// import 'package:hedieaty/src/screens/home_page.dart';
//
// class FriendDetailsView extends StatefulWidget {
//   const FriendDetailsView({super.key, this.userId, this.friendId});
//
//   final String? userId;
//   final String? friendId;
//
//   @override
//   State<FriendDetailsView> createState() => _FriendDetailsViewState();
// }
//
// class _FriendDetailsViewState extends State<FriendDetailsView> {
//   List<UserModel> friends = [];
//   bool isLoading = false;
//   bool isNewFriend = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadUsers();
//   }
//
//   Future<void> loadUsers() async {
//     try {
//       print('Fetching relations...');
//       final relation = await FirebaseFirestore.instance
//           .collection('friends')
//           .where('user_id', isEqualTo: UserSession.currentUserId)
//           .get();
//
//       print('Relation data: ${relation.docs.map((doc) => doc.data()).toList()}');
//       List<String> relationList = relation.docs
//           .map((doc) => Relation.fromJson(doc.data()).friend_id)
//           .toList();
//
//       // Include the current user's ID
//       relationList.add(UserSession.currentUserId!);
//
//       print('Fetching users not in relation list: $relationList');
//       final newFriends = await FirebaseFirestore.instance
//           .collection('Users')
//           .where('uid', whereNotIn: relationList)
//           .get();
//
//       print('Fetched users: ${newFriends.docs.map((doc) => doc.data()).toList()}');
//       List<UserModel> list = newFriends.docs
//           .map((user) => UserModel.fromJson(user.data()))
//           .toList();
//
//       setState(() {
//         friends = list;
//       });
//     } catch (e) {
//       print('Error loading users: $e');
//     }
//   }
//
//   void deleteFriend() {
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.pink.shade100,
//               Colors.yellow.shade100,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.pink),
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => HomePage()));
//                 },
//               ),
//               actions: [
//                 Visibility(
//                   visible: !isNewFriend,
//                   child: IconButton(
//                     onPressed: deleteFriend,
//                     icon: const Icon(Icons.delete, color: Colors.pink),
//                   ),
//                 ),
//               ],
//               title: const Text(
//                 'Add Friends',
//                 style: TextStyle(
//                     color: Colors.pink, fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: friends.isEmpty
//                     ? const Center(
//                   child: Text(
//                     'No Users yet\nDebug: Current friends: ${friends.toString()}',
//                     style: TextStyle(fontSize: 16, color: Colors.pink),
//                     textAlign: TextAlign.center,
//                   ),
//                 )
//                     : ListView.builder(
//                   itemCount: friends.length,
//                   itemBuilder: (context, index) {
//                     final user = friends[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: ListTile(
//                         title: Text(
//                           user.name ?? "",
//                           style: const TextStyle(
//                               color: Colors.black, fontSize: 18),
//                         ),
//                         subtitle: Text(
//                           user.email ?? "",
//                           style: const TextStyle(
//                               color: Colors.black54, fontSize: 16),
//                         ),
//                         trailing: FloatingActionButton(
//                           mini: true,
//                           onPressed: () {
//                             addFriend(friends[index].uid!);
//                             setState(() {});
//                           },
//                           child: const Icon(Icons.person_add, color: Colors.white),
//                           backgroundColor: Colors.pink,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void addFriend(String uid) async {
//     try {
//       print('Adding friend with UID: $uid');
//       final newFriendRef = FirebaseFirestore.instance.collection('friends').doc();
//       await newFriendRef.set(
//         Relation(user_id: UserSession.currentUserId!, friend_id: uid).toJson(),
//       );
//       print('Friend added successfully!');
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage()),
//       );
//     } catch (e) {
//       print('Error adding friend: $e');
//     }
//   }
// }
//
// class Relation {
//   int user_id;
//   String friend_id;
//
//   Relation({required this.user_id, required this.friend_id});
//
//   factory Relation.fromJson(Map<String, dynamic> json) => Relation(
//     user_id: json['user_id'] as int,
//     friend_id: json['friend_id'] as String,
//   );
//
//   Map<String, dynamic> toJson() => {
//     'user_id': user_id,
//     'friend_id': friend_id,
//   };
// }
