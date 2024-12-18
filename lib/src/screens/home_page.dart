import 'package:flutter/material.dart';
import 'package:hedieaty/src/widgets/bottom_navigator_bar_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Add navigation logic here
    switch (index) {
      case 0:
      // Navigate to Home Page
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
      // Navigate to Events Page
        Navigator.pushReplacementNamed(context, '/events');
        break;
      case 2:
      // Navigate to Gifts Page
        Navigator.pushReplacementNamed(context, '/gifts');
        break;
      case 3:
      // Navigate to Profile Page
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Page'),
      ),
      body: Center(
        child: Text('Selected Page: $_selectedIndex'),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}




