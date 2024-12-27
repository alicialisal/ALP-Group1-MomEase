import 'package:flutter/material.dart';
import 'package:front_end/mood_journaling.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomFloatingNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {
          // Fungsi ini dapat diubah sesuai dengan logika navigasi yang diinginkan
        },
      ),
    );
  }
}

class CustomFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomFloatingNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Selected: ${selectedIndex == 2 ? "Mood Tracker" : "Item $selectedIndex"}',
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
            height: 80,
            margin: EdgeInsets.only(bottom: 20).add(
              EdgeInsets.symmetric(horizontal: 15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.chat_bubble_outline, 'ChatBot', 0),
                _buildNavItem(Icons.self_improvement, 'Relaxation', 1),
                SizedBox(width: 75),
                _buildNavItem(Icons.article_outlined, 'Blogs', 3),
                _buildNavItem(Icons.person_outline, 'Profile', 4),
              ],
            ),
          ),

          // Tombol Tengah
          Positioned(
            bottom: 40,
            child: GestureDetector(
              onTap: () => onItemTapped(2), // Tombol ke Mood Tracker
              child: Container(
                height: 90,
                width: 90,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color(0xFFFFBCD9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.white,
                  size: 50,
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
      onTap: () => onItemTapped(index),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  selectedIndex == index ? Colors.blueAccent : Colors.black54,
              size: 30,
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
