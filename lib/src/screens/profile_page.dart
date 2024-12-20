import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:hedieaty/src/screens/authentication/model/user_model.dart';
import 'package:hedieaty/src/screens/authentication/model/user_session.dart';
import 'package:hedieaty/src/screens/authentication/model/user_db.dart';
import 'package:hedieaty/src/screens/events/view/event_list_page.dart';
import 'package:hedieaty/src/utils/constants.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  ProfilePage({required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final HedieatyUserDatabase userDatabase = HedieatyUserDatabase.instance;

  late UserModel user;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool receiveNotifications = true;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.forward();
    _loadUserData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.userId)
        .get();

    user = UserModel.fromJson(querySnapshot.docs.first.data());
    setState(() {
      nameController.text = user.name!;
      emailController.text = user.email!;
      receiveNotifications = user.preferences == 'true';
      isLoading = false;
    });
  }

  Future<void> _updateUserProfile() async {
    user = UserModel(
      id: widget.userId,
      name: nameController.text,
      email: emailController.text,
      preferences: receiveNotifications ? 'true' : 'false',
      profilePicture: user.profilePicture,
    );

    await userDatabase.update(user);
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient background
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 3),
            builder: (context, double value, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      christmasRed, christmasGold
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        'My Profile',
                        style: TextStyle(
                          color: christmasGold,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Animated Profile Picture
                    Center(
                      child: FadeTransition(
                        opacity: _controller,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: user.profilePicture != null
                              ? AssetImage(user.profilePicture!)
                              : const AssetImage(
                            'assets/images/profile_pictures/default.png',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Name Field with Custom Styling
                    buildCustomTextField(
                      hintText: 'Enter your name',
                      icon: Icons.person,
                      controller: nameController,
                    ),
                    const SizedBox(height: 16.0),

                    // Email Field with Custom Styling
                    buildCustomTextField(
                      hintText: 'Enter your email',
                      icon: Icons.email,
                      controller: emailController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16.0),

                    // Animated Notification Switch
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeOut,
                      )),
                      child: SwitchListTile(
                        title: Text('Receive Notifications',
                            style: TextStyle(color: christmasYellow)),
                        value: receiveNotifications,
                        onChanged: (bool value) {
                          setState(() {
                            receiveNotifications = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Save Changes and My Pledged Gifts Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: christmasYellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                          onPressed: _updateUserProfile,
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: christmasYellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventListPage(
                                  userID: widget.userId,
                                  userName: user.name ?? 'My Events',
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'My Pledged Gifts',
                            style: TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),

                    // Event List Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: christmasYellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventListPage(
                              userID: widget.userId,
                              userName: user.name ?? 'My Events',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'View My Events',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // Logout Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                      onPressed: logOut,
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logOut() {
    UserSession.clearSession();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginSignupPage()),
    );
  }

  // Custom method for text fields
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
