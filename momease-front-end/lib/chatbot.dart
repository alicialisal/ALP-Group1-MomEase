import 'package:flutter/material.dart';
import 'package:front_end/custom_navbar.dart';

class ChatBotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Chat with our chatbot!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFloatingNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {
          // Handle navigation based on the selected index
        },
      ),
    );
  }
}
