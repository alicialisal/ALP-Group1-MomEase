import 'package:flutter/material.dart';

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
              Navigator.pushNamed(context, '/mood_journaling');
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
            Navigator.pushNamed(context, '/chatbot');
            break;
          case 1:
            Navigator.pushNamed(context, '/relaxation');
            break;
          case 3:
            Navigator.pushNamed(context, '/blogs');
            break;
          case 4:
            Navigator.pushNamed(context, '/profile');
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
