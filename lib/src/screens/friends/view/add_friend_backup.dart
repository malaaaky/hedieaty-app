// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import 'package:hedieaty/src/screens/friends/model/friend_model.dart';
// import 'package:hedieaty/src/screens/home_page.dart';
//
// import 'package:hedieaty/src/screens/gifts/model/gift_db.dart';
// import 'package:hedieaty/src/screens/authentication/model/user_model.dart';
// import 'package:hedieaty/src/screens/authentication/model/user_session.dart';
//
// class FriendDetailsView extends StatefulWidget {
//   const FriendDetailsView({super.key, this.userId, this.friendId});
//
//   final int? userId;
//   final int? friendId;
//
//   @override
//   State<FriendDetailsView> createState() => _FriendDetailsViewState();
// }
//
// class _FriendDetailsViewState extends State<FriendDetailsView> {
//   HedieatyDatabase friendDatabase = HedieatyDatabase.instance;
//
//   List<UserModel> friends = [];
//   bool isLoading = false;
//   bool isNewFriend = true;
//
//   @override
//   void dispose() {
//     friends;
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadUsers();
//   }
//
//   Future<void> loadUsers() async {
//     final relation = await FirebaseFirestore.instance
//         .collection('friends')
//         .where('user_id', isEqualTo: UserSession.currentUserId)
//         .get();
//     List<int> relationList = [];
//     for (var x in relation.docs) {
//       relationList.add(Relation.fromJson(x.data()).friend_id);
//     }
//     relationList.add(UserSession.currentUserId!);
//     final newFriends = await FirebaseFirestore.instance
//         .collection('users')
//         .where('id', whereNotIn: relationList)
//         .get();
//
//     List<UserModel> list = [];
//     for (var user in newFriends.docs) {
//       list.add(UserModel.fromJson(user.data()));
//     }
//     setState(() {
//       friends = list;
//     });
//   }
//
//   deleteFriend() {
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
//                           builder: (context) => const HomePage()));
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
//                     'No Users yet',
//                     style: TextStyle(fontSize: 16, color: Colors.pink),
//                   ),
//                 )
//                     : ListView.builder(
//                   itemCount: friends.length,
//                   itemBuilder: (context, index) {
//                     final user = friends[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: ListTile(
//
//                         title: Text(
//                           user.name ?? "",
//                           style: const TextStyle(
//                               color: Colors.black, fontSize: 18),
//                         ),
//                         subtitle: Text(
//                           user.email.toString(),
//                           style: const TextStyle(
//                               color: Colors.black54, fontSize: 16),
//                         ),
//                         trailing: FloatingActionButton(
//                           mini: true,
//                           onPressed: () {
//                             addFriend(friends[index].id!);
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
//   void addFriend(int id) async {
//     final newFriendRef = FirebaseFirestore.instance.collection('friends').doc();
//     await newFriendRef
//         .set(
//         Relation(user_id: UserSession.currentUserId!, friend_id: id).toJson())
//         .then((_) => {
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()))
//     });
//
//     await friendDatabase.createFriend(
//         Friend(userId: UserSession.currentUserId!, friendId: id));
//   }
// }
//
// class Relation {
//   int user_id;
//   int friend_id;
//   Relation({this.user_id = 0, this.friend_id = 0});
//
//   factory Relation.fromJson(Map<String, Object?> json) => Relation(
//     user_id: json['user_id'] as int,
//     friend_id: json['friend_id'] as int,
//   );
//
//   Map<String, Object?> toJson() => {
//     'user_id': user_id,
//     'friend_id': friend_id,
//   };
// }
