import 'package:flutter/material.dart';
import 'package:front_end/blog_page/models/blog_model.dart';

import '../screens/blog_detail_screen.dart';
import '../widgets/blog_card.dart';

class BlogListScreen extends StatelessWidget {
  final List<Blog> blogs = [
  Blog(
    title: 'Self-Help Tips for Managing Baby Blues at Home',
    imagePath: 'assets/image1.jpg',
    content: 'The early days of motherhood can be overwhelming...',
    tips: [
      '1. Prioritize Rest: Lack of sleep can amplify feelings of stress and anxiety...',
      '2. Nourish Your Body with Healthy Foods: A balanced diet can significantly impact your mood...',
    ],
  ),
  Blog(
    title: 'Another Parenting Article',
    imagePath: 'assets/image2.jpg',
    content: 'This article covers various parenting strategies...',
    tips: [
      '1. Establish a Routine: Consistency helps children feel secure...',
      '2. Communicate Openly: Open dialogue fosters trust...',
    ],
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