import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'gift_details_page.dart';
import 'add_gift.dart';

import 'package:hedieaty/src/screens/gifts/model/gift_model.dart';
import 'package:hedieaty/src/screens/gifts/model/gift_db.dart';


class GiftListPage extends StatefulWidget {
  final int eventId;
  GiftListPage({required this.eventId});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final HedieatyDatabase giftDatabase = HedieatyDatabase.instance;
  List<GiftModel> gifts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGifts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadGifts() async {
    setState(() => isLoading = true);
    var loadGifts = await FirebaseFirestore.instance.collection('gifts')
    //.where(field)
        .get();
    for (var x in loadGifts.docs) {
      gifts.add(GiftModel.fromJson(x.data()));
      await giftDatabase.createGift(GiftModel.fromJson(x.data()));
    }
    gifts = gifts.where((gift) => gift.eventId == widget.eventId).toList();
    setState(() => isLoading = false);
  }

  Future<void> _addGift() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GiftDetailsView(eventId: widget.eventId)));
  }

  Future<void> _editGift(GiftModel gift) async {
    if (gift.status == 'available') {
      final updatedGift = gift.copy(name: 'Updated Gift Name', description: 'Updated Description');
      await giftDatabase.updateGift(updatedGift);
      _loadGifts();
    }
  }

  Future<void> _deleteGift(int id, bool status) async {
    if (status) {
      await giftDatabase.deleteGift(id);
      _loadGifts();
    }
  }

  void _viewGiftDetails(GiftModel gift) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiftDetailsPage(gift: gift),
      ),
    );
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
              title: const Text(
                'Gift List',
                style: TextStyle(color: Colors.pink, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.pink),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : gifts.isEmpty
                  ? const Center(
                child: Text(
                  'No gifts found',
                  style: TextStyle(fontSize: 16, color: Colors.pink),
                ),
              )
                  : ListView.builder(
                itemCount: gifts.length,
                itemBuilder: (context, index) {
                  final gift = gifts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: gift.status! ? Colors.red[300] : Colors.white,
                    child: ListTile(
                      title: Text(
                        gift.name ?? '',
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      subtitle: Text(
                        'Category: ${gift.category ?? 'N/A'}, Price: \$${gift.price ?? 'N/A'}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (gift.status == 'available')
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.pink),
                              onPressed: () => _editGift(gift),
                            ),
                          if (gift.status == 'available')
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteGift(gift.id!, gift.status!),
                            ),
                        ],
                      ),
                      onTap: () => _viewGiftDetails(gift),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGift,
        tooltip: 'Add Gift',
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
