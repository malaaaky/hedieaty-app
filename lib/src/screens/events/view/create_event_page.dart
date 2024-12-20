import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hedieaty/src/screens/gifts/model/gift_db.dart';
import 'package:hedieaty/src/screens/events/model/event_model.dart';


class EventDetailsPage extends StatefulWidget {
  final int? eventId;
  final int? friendId;

  const EventDetailsPage({Key? key, this.eventId, this.friendId}) : super(key: key);

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  HedieatyDatabase eventDatabase = HedieatyDatabase.instance;

  bool isNewEvent = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.eventId != null) {
      loadEvent(widget.eventId!);
    }
  }

  Future<void> loadEvent(int id) async {
    setState(() => isLoading = true);

    final docSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(id.toString())
        .get();

    if (docSnapshot.exists) {
      final event = EventModel.fromJson(docSnapshot.data()!);
      setState(() {
        isNewEvent = false;
        nameController.text = event.name ?? '';
        dateController.text = event.date ?? '';
        locationController.text = event.location ?? '';
        descriptionController.text = event.description ?? '';
      });
    }

    setState(() => isLoading = false);
  }

  Future<void> saveEvent() async {
    final event = EventModel(
      id: DateTime.now().millisecondsSinceEpoch,
      docId: widget.eventId?.toString(),
      name: nameController.text,
      date: dateController.text,
      location: locationController.text,
      description: descriptionController.text,
      userID: widget.friendId,
    );

    if (isNewEvent) {
      final newEventRef = FirebaseFirestore.instance.collection('events').doc();
      await newEventRef.set(event.toJson());
      await eventDatabase.createEvent(event);
    } else {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId.toString())
          .update(event.toJson());
    }

    Navigator.pop(context);
  }

  Future<void> pickDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink.shade100,
              Colors.yellow.shade100,
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
                isNewEvent ? 'Add Event' : 'Edit Event',
                style: const TextStyle(
                  color: Colors.pink,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.pink),
                  onPressed: saveEvent,
                ),
              ],
            ),
            isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Event Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: dateController,
                            decoration: InputDecoration(
                              labelText: 'Event Date',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            readOnly: true,
                            onTap: pickDate,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.calendar_today, color: Colors.pink),
                          onPressed: pickDate,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Event Preview:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${nameController.text}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Date: ${dateController.text}'),
                            Text('Location: ${locationController.text}'),
                            Text('Description: ${descriptionController.text}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
