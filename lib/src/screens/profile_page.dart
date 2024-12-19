import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/src/utils/constants.dart';

import 'events/event_list_page.dart';
import 'gifts/gift_list_page.dart';
import 'home_page.dart';
import 'package:hedieaty/src/widgets/profile_widgets.dart';


// to get documentId : FirebaseAuth.instance.currentUser!.uid
class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference Users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: Users.doc(widget.documentId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              // Handle loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Show a loading indicator
              }
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
            String? base64Image = data['profileimage'];
            return
              Scaffold(
                backgroundColor: christmasGold.withOpacity(0.6),
                body: Stack(
                  children: [
                    Container(
                      height: 230,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [christmasRed, christmasLightRed]),
                      ),
                    ),
                    CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          centerTitle: true,
                          pinned: true,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          expandedHeight: 140,
                          flexibleSpace: LayoutBuilder(
                            builder: (context, constraints) {
                              return FlexibleSpaceBar(
                                title: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: constraints.biggest.height <= 120
                                      ? 1
                                      : 0,
                                  child: Text(
                                    'Account',
                                    style: TextStyle(color: christmasWhite),
                                  ),
                                ),
                                background: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          christmasRed,
                                          christmasLightRed
                                        ]),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25, left: 30),
                                    child: Row(
                                      children: [CircleAvatar(
                                        radius: 50,
                                        backgroundImage: base64Image != null
                                            ? MemoryImage(base64Decode(base64Image)) // Use MemoryImage to decode and display
                                            : AssetImage('lib/assets/guest_avatar_img.png') as ImageProvider, // Default image if not available
                                      ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25),
                                          child: Text(
                                            data['name'].toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: christmasWhite,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.9,
                                decoration: BoxDecoration(
                                  color: christmasWhite,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                  children: [
                                    buildActionButton(
                                      context,
                                      label: 'Home',
                                      color: christmasRouge,
                                      textColor: christmasWhite,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                      },
                                    ),
                                    buildActionButton(
                                      context,
                                      label: 'Gifts',
                                      color: christmasGold,
                                      textColor: christmasRed,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GiftsPage(),
                                          ),
                                        );
                                      },
                                    ),
                                    buildActionButton(
                                      context,
                                      label: 'Events',
                                      color: christmasRouge,
                                      textColor: christmasWhite,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EventsPage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: christmasGold.withOpacity(0.1),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 150,
                                      child: Image(
                                        image: AssetImage(
                                            'lib/assets/christmas_bell_img.png'),
                                      ),
                                    ),
                                    const ProfileHeaderLabel(
                                      headerLabel: '  Account Info.  ',
                                    ),
                                    buildInfoCard([
                                       RepeatedListTile(
                                        icon: Icons.email,
                                        subTitle: data['email'],
                                        title: 'Email Address',
                                      ),
                                      const YellowDivider(),
                                      RepeatedListTile(
                                        icon: Icons.phone,
                                        subTitle: data['phone'],
                                        title: 'Phone No.',
                                      ),
                                      const YellowDivider(),
                                       RepeatedListTile(
                                        icon: Icons.location_pin,
                                        subTitle: data['address'],
                                        title: 'Address',
                                      ),
                                    ]),
                                    const ProfileHeaderLabel(
                                      headerLabel: '  Account Settings  ',
                                    ),
                                    buildInfoCard([
                                      RepeatedListTile(
                                        title: 'Edit Profile',
                                        icon: Icons.edit,
                                        onPressed: () {},
                                      ),
                                      const YellowDivider(),
                                      RepeatedListTile(
                                        title: 'Change Password',
                                        icon: Icons.lock,
                                        onPressed: () {},
                                      ),
                                      const YellowDivider(),
                                      RepeatedListTile(
                                        title: 'Log Out',
                                        icon: Icons.logout,
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Log Out'),
                                                content: Text(
                                                    'Are you sure to log out?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Close dialog
                                                    },
                                                    child: Text(
                                                        'No', style: TextStyle(
                                                        color: Colors.grey)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await FirebaseAuth
                                                          .instance
                                                          .signOut();
                                                      Navigator.pop(
                                                          context); // Close dialog
                                                      Navigator
                                                          .pushReplacementNamed(
                                                          context, '/login');
                                                    },
                                                    child: Text(
                                                        'Yes', style: TextStyle(
                                                        color: Colors.red)),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
          }
              return Center(child:
                  CircularProgressIndicator(
                    color: christmasGreen,
                  )
    );
            });

  }
}
