// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hedieaty/src/screens/authentication/model/user_model.dart';
// import 'package:hedieaty/src/screens/authentication/model/user_session.dart';
// import 'package:hedieaty/src/screens/authentication/model/user_db.dart';
//
// import 'package:hedieaty/src/screens/events/view/event_list_page.dart';
// import 'package:hedieaty/src/screens/events/model/event_model.dart';
//
// import 'package:hedieaty/src/screens/friends/view/add_friend_widget.dart';
// import 'package:hedieaty/src/screens/gifts/model/gift_db.dart';
// import '../utils/constants.dart';
// import 'profile_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   HedieatyDatabase eventDatabase = HedieatyDatabase.instance;
//   HedieatyUserDatabase userDatabase = HedieatyUserDatabase.instance;
//
//   TextEditingController searchController = TextEditingController();
//   List<EventModel> events = [];
//   List<UserModel> friends = [];
//   Map<int, int> friendEventCounts = {};
//
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     refreshEvents();
//     refreshFriends();
//   }
//
//   Future<void> refreshEvents() async {
//     final newEvents = await FirebaseFirestore.instance
//         .collection('events')
//         .get();
//     List<EventModel> eventList = [];
//     for (var x in newEvents.docs) {
//       eventList.add(EventModel.fromJson(x.data()));
//     }
//     setState(() {
//       events = eventList;
//     });
//   }
//
//   Future<void> refreshFriends() async {
//     // Fetch relations where the user is the current user
//     final relation = await FirebaseFirestore.instance
//         .collection('friends')
//         .where('user_id', isEqualTo: UserSession.currentUserId)
//         .get();
//
//     // Build the relation list
//     List<int> relationList = [];
//     for (var x in relation.docs) {
//       relationList.add(Relation.fromJson(x.data()).friend_id);
//     }
//
//     // Check if relationList is empty
//     if (relationList.isEmpty) {
//       print("relationList is empty. No friends to fetch.");
//       setState(() {
//         friends = [];
//         friendEventCounts = {};
//       });
//       return; // Exit the function early if no relations
//     }
//
//     // Fetch friends from Firestore
//     final newFriends = await FirebaseFirestore.instance
//         .collection('users')
//         .where('id', whereIn: relationList)
//         .get();
//
//     List<UserModel> list = [];
//     Map<int, int> eventCounts = {};
//
//     for (var user in newFriends.docs) {
//       final friend = UserModel.fromJson(user.data());
//       // Add a default profile picture if none exists
//       friend.profilePicture ??= 'assets/default_profile.png';
//       list.add(friend);
//
//       // Count events for each friend
//       final friendEvents =
//       events.where((event) => event.userID == friend.id).toList();
//       eventCounts[friend.id!] = friendEvents.length;
//     }
//
//     // Update state with the fetched friends and event counts
//     setState(() {
//       friends = list;
//       friendEventCounts = eventCounts;
//     });
//
//   }
//
//   void _onNavItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               EventListPage(userID: UserSession.currentUserId!.toInt(), userName: "My Events"),
//         ),
//       );
//     } else if (index == 2) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               ProfilePage(userId: UserSession.currentUserId!.toInt()),
//         ),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     friends;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [christmasRed, christmasGold],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               title: Text(
//                 'Home Page',
//                 style: TextStyle(color: christmasGold, fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               actions: [
//                 IconButton(
//                   icon: Icon(Icons.event, color: christmasGold),
//                   tooltip: 'View Events',
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => EventListPage(userID: UserSession.currentUserId!.toInt(), userName: "My Events")),
//                     );
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.account_circle, color: christmasGold),
//                   tooltip: 'Profile',
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ProfilePage(userId: UserSession.currentUserId!.toInt())),
//                     );
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.search, color: Colors.white),
//                   tooltip: 'Search Friends',
//                   onPressed: () {
//                     // Implement search functionality
//                   },
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: christmasYellow,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => EventListPage(userID: UserSession.currentUserId!.toInt(), userName: "My Events")),
//                   );
//                 },
//                 child: const Text(
//                   'Create Your Own Event/List',
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: friends.isEmpty
//                   ? Center(
//                 child: Text(
//                   'No friends to display.',
//                   style: TextStyle(fontSize: 16, color: christmasGold),
//                 ),
//               )
//                   : ListView.builder(
//                 itemCount: friends.length,
//                 itemBuilder: (context, index) {
//                   final friend = friends[index];
//                   final eventCount = friendEventCounts[friend.id] ?? 0;
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         radius: 40,
//                         child: Image.asset(friend.profilePicture??'assets/images/profile_pictures/pic6.jpg'),
//                       ),
//                       title: Text(
//                         friend.name ?? "",
//                         style: const TextStyle(color: Colors.black, fontSize: 18),
//                       ),
//                       subtitle: Text(
//                         eventCount > 0
//                             ? 'Upcoming Events: $eventCount'
//                             : 'No Upcoming Events',
//                         style: TextStyle(color: christmasGreen),
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => EventListPage(userID: friend.id, userName: friend.name.toString()),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const FriendDetailsView(),
//             ),
//           );
//         },
//         tooltip: 'Add Friend via Phone Number or Contact List',
//         backgroundColor: christmasYellow,
//         child: const Icon(Icons.person_add, color: Colors.white),
//       ),
//     );
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