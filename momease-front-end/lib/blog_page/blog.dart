import 'package:flutter/material.dart';
import 'package:front_end/blog_page/models/blog_model.dart';
import 'package:front_end/blog_page/screens/blog_detail_screen.dart';
import 'package:front_end/navbar/custom_navbar.dart';
import 'package:front_end/notification/notification.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final List<Blog> blogs = [
    Blog(
      title: 'Self-Help Tips for Managing Baby Blues at Home',
      content: 'This blog discusses ways to overcome baby blues...',
      imagePath: 'assets/images/blog1.png',
    ),
    Blog(
      title: 'Parenting 101: Building a Healthy Relationship',
      content: 'Learn how to foster trust and communication...',
      imagePath: 'assets/images/blog2.png',
    ),
  ];

  List<Blog> filteredBlogs = [];

  @override
  void initState() {
    super.initState();
    filteredBlogs = blogs; // Menampilkan semua blog pada awalnya
  }

  void _searchBlogs(String query) {
    setState(() {
      filteredBlogs = blogs
          .where(
              (blog) => blog.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghapus ikon back default
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container kiri kosong
            Container(
              width: 40, // Sesuaikan ukuran jika perlu
              height: 40,
              color: Colors.transparent, // Kosong tanpa icon
            ),

            // Container tengah dengan teks
            Container(
              child: Text(
                'Blogs',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Container kanan dengan icon notifikasi
            Container(
              child: IconButton(
                icon: Icon(Icons.notifications_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotificationPage()), // Ganti dengan widget halaman tujuan
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Blogs.',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Learn and explore your parenting thoughts in here.',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search blogs...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _searchBlogs, // Memanggil fungsi pencarian
                ),
                SizedBox(height: 20),
                // Menampilkan blog yang terfilter
                for (var blog in filteredBlogs)
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16.0), // Jarak antar card
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogDetailScreen(blog: blog),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Read blog →',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
