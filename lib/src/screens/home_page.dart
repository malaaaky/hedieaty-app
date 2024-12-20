import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/src/screens/authentication/model/user_model.dart';
import 'package:hedieaty/src/screens/authentication/model/user_session.dart';
import 'package:hedieaty/src/screens/authentication/model/user_db.dart';
import 'package:hedieaty/src/screens/events/view/event_list_page.dart';
import 'package:hedieaty/src/screens/events/model/event_model.dart';
import 'package:hedieaty/src/screens/friends/view/add_friend_widget.dart';
import '../utils/constants.dart';
import 'profile_page.dart';
import 'package:hedieaty/src/screens/friends/model/frienduser.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HedieatyUserDatabase userDatabase = HedieatyUserDatabase.instance;

  TextEditingController searchController = TextEditingController();
  List<EventModel> events = [];
  List<UserModel> friends = [];
  Map<int, int> friendEventCounts = {};

  int _selectedIndex = 0;

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
      relationList.add(FriendUser.fromJson(x.data()).friend_id);
    }

    if (relationList.isEmpty) {
      print("relationList is empty. No friends to fetch.");
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

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EventListPage(userID: UserSession.currentUserId!.toInt(), userName: "My Events"),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfilePage(userId: UserSession.currentUserId!.toInt()),
        ),
      );
    }
  }

  @override
  void dispose() {
    friends;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hedieaty",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: christmasRed,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
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
            // Row for buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: christmasYellow,
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
                              userName: "My Events"),
                        ),
                      );
                    },
                    child: const Text(
                      'Create Your Event',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: christmasYellow,
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
                              userName: "My Events"),
                        ),
                      );
                    },
                    child: const Text(
                      'Events',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: christmasYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                              userId: UserSession.currentUserId!.toInt()),
                        ),
                      );
                    },
                    child: const Text(
                      'Profile',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: friends.isEmpty
                  ? Center(
                child: Text(
                  'No friends to display.',
                  style: TextStyle(fontSize: 16, color: christmasGold),
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
                        child: Image.asset(friend.profilePicture ??
                            'assets/images/profile_pictures/pic6.jpg'),
                      ),
                      title: Text(
                        friend.name ?? "",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 18),
                      ),
                      subtitle: Text(
                        eventCount > 0
                            ? 'Upcoming Events: $eventCount'
                            : 'No Upcoming Events',
                        style: TextStyle(color: christmasGreen),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventListPage(
                                userID: friend.id,
                                userName: friend.name.toString()),
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
        backgroundColor: christmasYellow,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}

