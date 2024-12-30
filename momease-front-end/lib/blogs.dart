import 'package:flutter/material.dart';

class BlogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Blog Post 1'),
            subtitle: Text('Learn about mood tracking!'),
            onTap: () {
              // Action when tapped
            },
          ),
          ListTile(
            title: Text('Blog Post 2'),
            subtitle: Text('How relaxation helps your health.'),
            onTap: () {
              // Action when tapped
            },
          ),
          // Add more blogs as needed
        ],
      ),
    );
  }
}
