import 'package:flutter/material.dart';
import '../models/blog_model.dart';
import '../screens/blog_detail_screen.dart';
import '../widgets/blog_card.dart';

class BlogListScreen extends StatelessWidget {
  final List<Blog> blogs = [
    Blog(
      title: 'Self-Help Tips for Managing Baby Blues at Home',
      imagePath: 'assets/image1.jpg',
      content: 'Insert the content of the blog here...',
    ),
    Blog(
      title: 'Another Parenting Article',
      imagePath: 'assets/image2.jpg',
      content: 'Another blog content goes here...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Blogs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add notification logic here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search here...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  final blog = blogs[index];
                  return BlogCard(
                    title: blog.title,
                    imagePath: blog.imagePath,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetailScreen(blog: blog),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
