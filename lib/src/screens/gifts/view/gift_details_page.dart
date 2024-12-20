import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hedieaty/src/screens/gifts/model/gift_model.dart';
import 'package:hedieaty/src/utils/constants.dart';

class GiftDetailsPage extends StatefulWidget {
  final GiftModel gift;
  const GiftDetailsPage({required this.gift, Key? key}) : super(key: key);

  @override
  State<GiftDetailsPage> createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
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
                  christmasRed,
                  christmasGold,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        'Pledge Your Gift',
                        style: TextStyle(
                          color: christmasGold,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: christmasGold),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${widget.gift.name ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: christmasGold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Category: ${widget.gift.category ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Price: \$${widget.gift.price ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Description: ${widget.gift.description ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Row with toggle switch for 'Is Pledged'
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,  // Align elements to start (left)
                      crossAxisAlignment: CrossAxisAlignment.center, // Center the text and switch vertically
                      children: [
                        const Text(
                          'Is Pledged',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),  // Add some space between the text and the switch
                        CupertinoSwitch(
                          value: widget.gift.status!,
                          activeColor: christmasGold,
                          onChanged: (value) {
                            setState(() {
                              widget.gift.status = value;
                              pleadgeGift();
                            });
                          },
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Update the status in Firebase
  void pleadgeGift() async {
    await FirebaseFirestore.instance
        .collection('gifts')
        .doc(widget.gift.docId)
        .update({'status': widget.gift.status});
  }
}
