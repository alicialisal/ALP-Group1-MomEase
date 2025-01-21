import 'package:flutter/material.dart';
import 'package:front_end/blog_page/blog.dart';
import 'package:front_end/chatbot.dart';
import 'package:front_end/edit_profile.dart';
import 'package:front_end/kegiatan_relaksasi/search_page.dart';
import 'package:front_end/mood_journaling.dart';

class CustomFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomFloatingNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 60,
          margin: EdgeInsets.only(bottom: 15).add(
            EdgeInsets.symmetric(horizontal: 10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
              _buildNavItem(Icons.chat_bubble_outline, 'ChatBot', 0, context),
              _buildNavItem(Icons.self_improvement, 'Relaxation', 1, context),
              SizedBox(width: 60),
              _buildNavItem(Icons.article_outlined, 'Blogs', 3, context),
              _buildNavItem(Icons.person_outline, 'Profile', 4, context),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoodTrackerScreen()),
              );
            },
            child: Container(
              height: 70,
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
                size: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatBotPage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RelaxationScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BlogPage()),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileView()),
            );
            break;
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  selectedIndex == index ? Colors.blueAccent : Colors.black54,
              size: 24,
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
