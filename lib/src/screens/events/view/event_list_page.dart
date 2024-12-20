
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hedieaty/src/screens/authentication/model/user_session.dart';
import 'package:hedieaty/src/screens/gifts/view/gift_list_page.dart';
import 'package:hedieaty/src/screens/events/view/create_event_page.dart';
import 'package:hedieaty/src/screens/events/model/event_model.dart';
import 'package:hedieaty/src/utils/constants.dart';


class EventListPage extends StatefulWidget {
  final int? userID;
  final String userName;

  const EventListPage({Key? key, this.userID, required this.userName}) : super(key: key);

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<EventModel> events = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setupEventListener();
  }

  void setupEventListener() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('user_id', isEqualTo: widget.userID)
        .get();
    List<EventModel> list = [];
    for (var event in querySnapshot.docs) {
      list.add(EventModel.fromJson(event.data()));
    }
    if (mounted) {
      setState(() => events = list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              christmasRed,
              christmasGold
            ],
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
                widget.userName,
                style: TextStyle(
                  color: christmasGold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // actions: [
              //   if (widget.userID == UserSession.currentUserId)
              //     IconButton(
              //       icon: Icon(Icons.add, color: christmasGold),
              //       onPressed: () async {
              //         await Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>
              //                 EventDetailsPage(friendId: UserSession
              //                     .currentUserId),
              //           ),
              //         );
              //         setupEventListener();
              //       },
              //     ),
              // ],
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : events.isEmpty
                  ? Center(
                child: Text(
                  'No events yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: christmasYellow,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        event.name ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        event.description ?? '',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GiftListPage(eventId: event.id!),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: christmasGold),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetailsPage(
                                        eventId: event.id,
                                        friendId: UserSession.currentUserId,
                                      ),
                                ),
                              ).then((_) => setupEventListener());
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.userID == UserSession.currentUserId
          ? FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(friendId: UserSession.currentUserId),
            ),
          );
          setupEventListener();
        },
        backgroundColor: christmasYellow,
        child: Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }

  void deleteEvent(EventModel event) {
    print('deleted');
  }
}