import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hedieaty/src/screens/authentication/model/user_model.dart';
import 'package:hedieaty/src/screens/authentication/model/user_session.dart';

import 'package:hedieaty/src/widgets/bottom_navigator_bar_widget.dart';
import 'package:hedieaty/src/utils/constants.dart';

import 'package:hedieaty/src/screens/events/view/event_list_page.dart';
import 'package:hedieaty/src/screens/friends/view/add_friend_widget.dart';
import 'package:hedieaty/src/screens/profile_page.dart';

import 'events/model/event_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //for bottom navigator
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here
    switch (index) {
      case 0:
      // Navigate to Home Page
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
      // Navigate to Events Page
        Navigator.pushReplacementNamed(context, '/events');
        break;
      case 2:
      // Navigate to Gifts Page
        Navigator.pushReplacementNamed(context, '/gifts');
        break;
      case 3:
      // Navigate to Profile Page
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  TextEditingController searchController = TextEditingController();

  List<EventModel> events = [];
  List<UserModel> friends = [];
  Map<int, int> friendEventCounts = {};

  @override
  void initState() {
    super.initState();
    refreshEvents();
    refreshFriends();
  }

  Future<void> refreshEvents() async {
    final newEvents = await FirebaseFirestore.instance.collection('events').get();
    List<EventModel> eventList = [];
    for (var x in newEvents.docs) {
      eventList.add(EventModel.fromJson(x.data()));
    }
    setState(() {
      events = eventList;
    });
  }

  Future<void> refreshFriends() async {
    final relation = await FirebaseFirestore.instance
        .collection('friends')
        .where('user_id', isEqualTo: UserSession.currentUserId)
        .get();

    List<int> relationList = [];
    for (var x in relation.docs) {
      relationList.add(Relation.fromJson(x.data()).friend_id);
    }

    if (relationList.isEmpty) {
      setState(() {
        friends = [];
        friendEventCounts = {};
      });
      return;
    }

    final newFriends = await FirebaseFirestore.instance
        .collection('users')
        .where('id', whereIn: relationList)
        .get();

    List<UserModel> list = [];
    Map<int, int> eventCounts = {};

    for (var user in newFriends.docs) {
      final friend = UserModel.fromJson(user.data());
      friend.profilePicture ??= 'assets/default_profile.png';
      list.add(friend);

      final friendEvents =
      events.where((event) => event.userID == friend.id).toList();
      eventCounts[friend.id!] = friendEvents.length;
    }

    setState(() {
      friends = list;
      friendEventCounts = eventCounts;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [christmasRed, christmasGold],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Home Page',
                style: TextStyle(
                  color: christmasWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.event, color: christmasWhite),
                  tooltip: 'View Events',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventListPage(
                          userID: UserSession.currentUserId!.toInt(),
                          userName: "My Events",
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle, color: christmasWhite),
                  tooltip: 'Profile',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          documentId : FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search, color: christmasWhite),
                  tooltip: 'Search Friends',
                  onPressed: () {
                    // Implement search functionality
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: christmasRouge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventListPage(
                        userID: UserSession.currentUserId!.toInt(),
                        userName: "My Events",
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Create Your Own Event/List',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: friends.isEmpty
                  ? Center(
                child: Text(
                  'No friends to display.',
                  style: TextStyle(
                    fontSize: 16,
                    color: christmasWhite,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  final eventCount = friendEventCounts[friend.id] ?? 0;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundImage: friend.profilePicture != null
                            ? AssetImage(friend.profilePicture!)  // Make sure the profilePicture is not null and cast it appropriately
                            : AssetImage('lib/assets/guest_avatar_img.png'), // Fallback image
                        child: friend.profilePicture == null
                            ? const Icon(Icons.person) // Placeholder icon if no image is available
                            : null,
                      ),
                      title: Text(
                        friend.name ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        eventCount > 0
                            ? 'Upcoming Events: $eventCount'
                            : 'No Upcoming Events',
                        style: TextStyle(color: christmasLightRed),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventListPage(
                              userID: friend.id,
                              userName: friend.name.toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FriendDetailsView(),
            ),
          );
        },
        tooltip: 'Add Friend via Phone Number or Contact List',
        backgroundColor: christmasRouge,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Relation {
  int user_id;
  int friend_id;
  Relation({this.user_id = 0, this.friend_id = 0});

  factory Relation.fromJson(Map<String, Object?> json) => Relation(
    user_id: json['user_id'] as int,
    friend_id: json['friend_id'] as int,
  );

  Map<String, Object?> toJson() => {
    'user_id': user_id,
    'friend_id': friend_id,
  };
}
