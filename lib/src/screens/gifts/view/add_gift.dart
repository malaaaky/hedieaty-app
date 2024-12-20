import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'gift_list_page.dart';

import 'package:hedieaty/src/screens/gifts/model/gift_model.dart';
import 'package:hedieaty/src/screens/gifts/model/gift_db.dart';

//create a gift--> add_gift
class GiftDetailsView extends StatefulWidget {
  const GiftDetailsView({super.key, this.eventId});

  final int? eventId;

  @override
  State<GiftDetailsView> createState() => _GiftDetailsViewState();
}

class _GiftDetailsViewState extends State<GiftDetailsView> {
  HedieatyDatabase giftDatabase = HedieatyDatabase.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  late GiftModel gift;
  bool isLoading = false;
  bool isNewGift = false;
  bool isFavorite = false;

  createGift() async {
    setState(() {
      isLoading = true;
    });
    final newUserRef = FirebaseFirestore.instance.collection('gifts').doc();
    final newGift = GiftModel(
      id: (newUserRef.id.hashCode),
      docId: newUserRef.id,
      name: nameController.text,
      description: descriptionController.text,
      category: categoryController.text,
      price: priceController.text,
      eventId: widget.eventId,
      status: false, // Status indicates if a gift is pledged or available
    );

    await newUserRef.set(newGift.toJson()).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => GiftListPage(eventId: widget.eventId!)),
      );
    });

    setState(() {
      isLoading = false;
    });
  }

  deleteGift() {
    giftDatabase.deleteGift(gift.id!);
    Navigator.pop(context);
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
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.pink.shade700),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GiftListPage(eventId: widget.eventId!)),
                    );
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pink.shade700,
                    ),
                  ),
                  if (!isNewGift)
                    IconButton(
                      onPressed: deleteGift,
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  IconButton(
                    onPressed: createGift,
                    icon: const Icon(Icons.save, color: Colors.green),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        cursorColor: Colors.pink.shade700,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Gift Name',
                          border: const UnderlineInputBorder(),
                          hintStyle: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 20,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.pink.shade700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        cursorColor: Colors.pink.shade700,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Description',
                          border: const UnderlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.pink.shade700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: categoryController,
                        cursorColor: Colors.pink.shade700,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Category',
                          border: const UnderlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.pink.shade700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: priceController,
                        cursorColor: Colors.pink.shade700,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Price',
                          border: const UnderlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.pink.shade700),
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
      ),
    );
  }
}
