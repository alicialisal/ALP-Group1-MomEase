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
      home: CustomFloatingNavBar(),
    );
  }
}

class CustomFloatingNavBar extends StatefulWidget {
  @override
  _CustomFloatingNavBarState createState() => _CustomFloatingNavBarState();
}

class _CustomFloatingNavBarState extends State<CustomFloatingNavBar> {
  int _selectedIndex = 0;

  // Fungsi untuk navigasi ke halaman yang sesuai
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Daftar halaman
    List<Widget> pages = [
      // ChatBotPage(),
      // RelaxationPage(),
      MoodJournaling(),
      // BlogsPage(),
      // ProfilePage(),
    ];

    // Navigasi ke halaman baru
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pages[index]),
    );
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
              onTap: () => _onItemTapped(2), // Tombol ke Mood Tracker
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
      onTap: () => _onItemTapped(index),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  _selectedIndex == index ? Colors.blueAccent : Colors.black54,
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
