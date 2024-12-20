import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/src/utils/constants.dart';

import 'gift_list_page.dart';
import 'package:hedieaty/src/screens/gifts/model/gift_model.dart';

//add gift
class GiftDetailsView extends StatefulWidget {
  const GiftDetailsView({super.key, this.eventId});
  final int? eventId;

  @override
  State<GiftDetailsView> createState() => _GiftDetailsViewState();
}

class _GiftDetailsViewState extends State<GiftDetailsView> {

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

    //firebase collection
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: christmasGold),
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
                  if (!isNewGift)
                    IconButton(
                      onPressed: deleteGift,
                      icon: const Icon(Icons.delete, color: Colors.red),
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
                      buildCustomTextField(
                        hintText: 'Gift Name',
                        icon: Icons.card_giftcard,
                        controller: nameController,
                      ),
                      const SizedBox(height: 16),
                      buildCustomTextField(
                        hintText: 'Description',
                        icon: Icons.description,
                        controller: descriptionController,
                      ),
                      const SizedBox(height: 16),
                      buildCustomTextField(
                        hintText: 'Category',
                        icon: Icons.category,
                        controller: categoryController,
                      ),
                      const SizedBox(height: 16),
                      buildCustomTextField(
                        hintText: 'Price',
                        icon: Icons.money,
                        controller: priceController,
                      ),
                      const SizedBox(height: 32),
                      // Save Gift Button
                      ElevatedButton(
                        onPressed: createGift,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: christmasYellow,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Save Gift',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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

  Widget buildCustomTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    VoidCallback? onPasswordToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: onPasswordToggle != null
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: onPasswordToggle,
        )
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
    );
  }
}
