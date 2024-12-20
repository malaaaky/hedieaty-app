import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/src/utils/constants.dart';

import 'gift_details_page.dart';
import 'add_gift.dart';
import 'package:hedieaty/src/screens/gifts/model/gift_model.dart';

class GiftListPage extends StatefulWidget {
  final int eventId;
  const GiftListPage({required this.eventId, Key? key}) : super(key: key);

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  List<GiftModel> gifts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGifts();
  }

  Future<void> _loadGifts() async {
    setState(() => isLoading = true);
    try {
      var loadGifts = await FirebaseFirestore.instance.collection('gifts')
          .get();
      List<GiftModel> loadedGifts = loadGifts.docs
          .map((doc) => GiftModel.fromJson(doc.data()))
          .toList();
      // Filter the gifts related to the current eventId
      gifts =
          loadedGifts.where((gift) => gift.eventId == widget.eventId).toList();
    } catch (e) {
      // Handle any errors during data fetching
      debugPrint("Error loading gifts: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _addGift() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => GiftDetailsView(eventId: widget.eventId)),
    );
  }

  Future<void> _editGift(GiftModel gift) async {
    if (gift.status == 'available') {
      final updatedGift = gift.copy(
          name: 'Updated Gift Name', description: 'Updated Description');
      _loadGifts();
    }
  }

  Future<void> _deleteGift(int id, bool status) async {
    if (status) {
      _loadGifts();
    }
  }

  void _viewGiftDetails(GiftModel gift) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GiftDetailsPage(gift: gift)),
    );
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
                'Gift List',
                style: TextStyle(color: christmasGold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: christmasGold),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : gifts.isEmpty
                  ? Center(
                child: Text(
                  'No gifts found',
                  style: TextStyle(fontSize: 16, color: christmasGold),
                ),
              )
                  : ListView.builder(
                itemCount: gifts.length,
                itemBuilder: (context, index) {
                  final gift = gifts[index];
                  return _buildGiftCard(gift);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGift,
        tooltip: 'Add Gift',
        backgroundColor: christmasYellow,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildGiftCard(GiftModel gift) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: gift.status! ? christmasLightRed : Colors.white,
      child: ListTile(
        title: Text(
          gift.name ?? '',
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        subtitle: Text(
          'Category: ${gift.category ?? 'N/A'}, Price: \$${gift.price ??
              'N/A'}',
          style: const TextStyle(color: Colors.black54),
        ),
        onTap: () => _viewGiftDetails(gift),
      ),
    );
  }

}