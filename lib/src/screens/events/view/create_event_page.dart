import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/src/screens/events/model/event_model.dart';
import 'package:hedieaty/src/utils/constants.dart';


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
      id: DateTime
          .now()
          .millisecondsSinceEpoch,
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

  Widget buildCustomTextField({
    required String hintText,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: hintText == 'Event Date'
            ? Icon(Icons.calendar_today, color: Colors.white)
            : null,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.red.withOpacity(0.2),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onTap: onTap,
    );
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
                isNewEvent ? 'Add Event' : 'Edit Event',
                style: TextStyle(
                  color: christmasGold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [

              ],
            ),
            isLoading
                ? const Expanded(
                child: Center(child: CircularProgressIndicator()))
                : Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCustomTextField(
                      hintText: 'Event Name',
                      controller: nameController,
                    ),
                    const SizedBox(height: 16),
                    buildCustomTextField(
                      hintText: 'Event Date',
                      controller: dateController,
                      readOnly: true,
                      onTap: pickDate,
                    ),
                    const SizedBox(height: 16),
                    buildCustomTextField(
                      hintText: 'Location',
                      controller: locationController,
                    ),
                    const SizedBox(height: 16),
                    buildCustomTextField(
                      hintText: 'Description',
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: saveEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: christmasRouge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: const Text(
                          'Save Event',
                          style: TextStyle(fontSize: 18, color: Colors.white),
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