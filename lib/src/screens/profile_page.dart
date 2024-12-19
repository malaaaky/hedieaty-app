import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/src/utils/constants.dart';

import 'events/event_list_page.dart';
import 'gifts/gift_list_page.dart';
import 'home_page.dart';
import 'package:hedieaty/src/widgets/profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        opacity: constraints.biggest.height <= 120 ? 1 : 0,
                        child: Text(
                          'Account',
                          style: TextStyle(color: christmasWhite),
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [christmasRed, christmasLightRed]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, left: 30),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    'lib/assets/guest_avatar_img.png'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text(
                                  'guest'.toUpperCase(),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            const RepeatedListTile(
                              icon: Icons.email,
                              subTitle: 'example@email.com',
                              title: 'Email Address',
                            ),
                            const YellowDivider(),
                            const RepeatedListTile(
                              icon: Icons.phone,
                              subTitle: '+11111',
                              title: 'Phone No.',
                            ),
                            const YellowDivider(),
                            const RepeatedListTile(
                              icon: Icons.location_pin,
                              subTitle: 'example: 140 - st - New Gersy',
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
                                      content: Text('Are you sure to log out?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Close dialog
                                          },
                                          child: Text('No', style: TextStyle(
                                              color: Colors.grey)),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.pop(
                                                context); // Close dialog
                                            Navigator.pushReplacementNamed(
                                                context, '/login');
                                          },
                                          child: Text('Yes', style: TextStyle(
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
}