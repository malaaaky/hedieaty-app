import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:hedieaty/src/screens/authentication/model/user_session.dart';
import 'package:hedieaty/src/screens/gifts/model/gift_model.dart';
import 'package:hedieaty/src/screens/gifts/model/gift_db.dart';

class MyPledgedGiftsPage extends StatefulWidget {
  @override
  State<MyPledgedGiftsPage> createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  final HedieatyDatabase giftDatabase = HedieatyDatabase.instance;
  List<GiftModel> pledgedGifts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPledgedGifts();
  }

  Future<void> _loadPledgedGifts() async {
    setState(() => isLoading = true);

    try {
      // Fetch all gifts from Firestore filtered by the current user's ID and pledged status
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('gifts')
          .where('userID', isEqualTo: UserSession.currentUserId)
          .where('status', isEqualTo: true)
          .get();

      // Map Firestore documents to the `GiftModel`
      pledgedGifts = querySnapshot.docs
          .map((doc) => GiftModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Handle errors gracefully
      print('Error loading pledged gifts: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }


  // Edit the pledged gift and update Firestore
  Future<void> _editPledgedGift(GiftModel gift) async {
    final updatedGift = gift.copy(
      name: 'Updated Gift Name',
      description: 'Updated Description',
    );

    // Update in SQLite
    await giftDatabase.updateGift(updatedGift);

    // Update in Firestore
    if (updatedGift.docId != null) {
      await FirebaseFirestore.instance
          .collection('gifts')
          .doc(updatedGift.docId)
          .update(updatedGift.toJson());
    }

    _loadPledgedGifts();
  }

  // Delete the pledged gift from SQLite and Firestore
  Future<void> _deletePledgedGift(int id, String? docId) async {
    // Delete from SQLite
    await giftDatabase.deleteGift(id);

    // Delete from Firestore
    if (docId != null) {
      await FirebaseFirestore.instance.collection('gifts').doc(docId).delete();
    }

    _loadPledgedGifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
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
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'My Pledged Gifts',
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : pledgedGifts.isEmpty
                      ? const Center(
                    child: Text(
                      'No pledged gifts found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: pledgedGifts.length,
                    itemBuilder: (context, index) {
                      final gift = pledgedGifts[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            gift.name ?? 'Unknown Gift',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Category: ${gift.category ?? 'N/A'}\nPrice: \$${gift.price ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _editPledgedGift(gift),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _deletePledgedGift(gift.id!, gift.docId),
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
        ],
      ),
    );
  }
}