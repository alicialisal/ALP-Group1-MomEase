import 'package:flutter/material.dart';

// Pastikan halaman yang sesuai ada
import 'chatbot.dart';
import 'relaxation.dart';
import 'mood_journaling.dart';
import 'blogs.dart';
import 'profile.dart';

// Modifikasi CustomFloatingNavBar
class CustomFloatingNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomFloatingNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _CustomFloatingNavBarState createState() => _CustomFloatingNavBarState();
}

class _CustomFloatingNavBarState extends State<CustomFloatingNavBar> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    ChatBotPage(),
    RelaxationPage(),
    MoodJournaling(),
    BlogsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Bottom Navigation Bar
          Container(
            height: 60, // Kurangi tinggi navbar
            margin: EdgeInsets.only(bottom: 15).add(
              EdgeInsets.symmetric(horizontal: 10),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: 15, vertical: 5), // Kurangi padding
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.chat_bubble_outline, 'ChatBot', 0),
                _buildNavItem(Icons.self_improvement, 'Relaxation', 1),
                SizedBox(width: 60), // Kurangi spasi untuk tombol tengah
                _buildNavItem(Icons.article_outlined, 'Blogs', 3),
                _buildNavItem(Icons.person_outline, 'Profile', 4),
              ],
            ),
          ),

          // Tombol Tengah (Mood Tracker)
          Positioned(
            bottom: 30, // Sesuaikan posisi
            // right: -2,
            child: GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                height: 70, // Perkecil ukuran tombol tengah
                width: 70,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color(0xFFFFBCD9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.white,
                  size: 40, // Perkecil ukuran ikon
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
        padding: EdgeInsets.symmetric(horizontal: 5), // Kurangi padding item
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  _selectedIndex == index ? Colors.blueAccent : Colors.black54,
              size: 24, // Perkecil ukuran ikon
            ),
            SizedBox(height: 3), // Kurangi jarak
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10, // Perkecil ukuran teks
              ),
            ),
          ],
        ),
      ),
    );
  }
}
