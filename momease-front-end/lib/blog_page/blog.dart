import 'package:flutter/material.dart';
import 'package:front_end/blog_page/models/blog_model.dart';
import 'package:front_end/blog_page/screens/blog_detail_screen.dart';
import 'package:front_end/custom_navbar.dart';

class BlogPage extends StatelessWidget {
  final List<Blog> blogs = [
    Blog(
      title: 'Self-Help Tips for Managing Baby Blues at Home',
      content: 'This blog discusses ways to overcome baby blues...',
      imagePath: 'assets/image1.jpg',
    ),
    Blog(
      title: 'Parenting 101: Building a Healthy Relationship',
      content: 'Learn how to foster trust and communication...',
      imagePath: 'assets/image2.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Blogs'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learn and explore your parenting thoughts in here.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 20),
              // Dynamically generate blog cards
              for (var blog in blogs)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetailScreen(blog: blog),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.asset(
                            blog.imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                blog.title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Read blog →',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomFloatingNavBar(
        selectedIndex: 3,
        onItemTapped: (index) {
          // Handle navigation based on the selected index
        },
      ),
    );
  }
}
