import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Selected: ${_selectedIndex == 2 ? "Mood Tracker" : "Item $_selectedIndex"}',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Bottom Navigation Bar
          Container(
            height: 80, // Increased height to allow more space
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.chat_bubble_outline, 'ChatBot', 0),
                _buildNavItem(Icons.self_improvement, 'Relaxation', 1),
                SizedBox(width: 75), // Space for the central button
                _buildNavItem(Icons.article_outlined, 'Blogs', 3),
                _buildNavItem(Icons.person_outline, 'Profile', 4),
              ],
            ),
          ),

          // Horizontal Line Beneath Central Button
          Positioned(
            bottom: 10,
            child: Container(
              height: 2,
              width: 80,
            ),
          ),

          // Central Button
          Positioned(
            bottom: 35, // Adjust the vertical positioning
            child: GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                height: 100, // Slightly smaller size
                width: 110, // Adjusted width
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color(0xFFFFBCD9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.white,
                  size: 60, // Slightly smaller icon
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: _selectedIndex == index ? Colors.blueAccent : Colors.black54,
              size: 30, // Increased size for balance
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
