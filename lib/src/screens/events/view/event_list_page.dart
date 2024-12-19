import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hedieaty/src/screens/home_page.dart';
import '../../../utils/constants.dart';
import '../../authentication/model/user_session.dart';
import '../model/event_model.dart';


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
              actions: [
                if (widget.userID==UserSession.currentUserId)
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                          //TODO raga3i comment wa sheli homepage
                          // builder: (context) => EventDetailsPage(friendId: UserSession.currentUserId),
                        ),
                      );
                      setupEventListener();
                    },
                  ),
              ],
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
                    color: christmasGold,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                            builder: (context) => HomePage(),
                            //TODO raga3i comment wa sheli homepage
                            // builder: (context) => GiftListPage(eventId: event.id!),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                  //TODO raga3i comment wa sheli homepage
                                  // builder: (context) => EventDetailsPage(
                                  //   eventId: event.id,
                                  //   friendId: UserSession.currentUserId,
                                  // ),
                                ),
                              ).then((_) => setupEventListener());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: (){
                              deleteEvent(event);

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
    );
  }

  void deleteEvent(EventModel event) async{
    var collection =  FirebaseFirestore.instance
        .collection('events');
    await collection.doc(event.docId.toString())
        .delete();
    setupEventListener();
    dev.log('x ${event.description.toString()}');
  }
}
