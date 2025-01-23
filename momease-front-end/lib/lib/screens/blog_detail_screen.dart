import 'package:flutter/material.dart';
import 'package:front_end/blog_page/models/blog_model.dart';

import '../widgets/comment_widget.dart';

class BlogDetailScreen extends StatefulWidget {
  final Blog blog;

  const BlogDetailScreen({Key? key, required this.blog}) : super(key: key);

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  final List<Comment> comments = [];
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        comments.add(Comment(
          content: _commentController.text,
          userImageUrl: 'https://via.placeholder.com/40',
          username: 'User',
          timestamp: DateTime.now(),
          replies: [],
          thumbsUp: 0,
          thumbsDown: 0,
        ));
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blog.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blog Image
            Image.asset(
              widget.blog.imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),

            // Blog Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                widget.blog.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Blog Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                widget.blog.content,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Tips Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Self-Help Tips for Managing Baby Blues at Home",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                "1. Prioritize Rest",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Tip Image with Padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust this padding as needed
              child: Image.asset(
                'assets/rest_tips.jpg', // Replace with your image path
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300
              ),
            ),

             const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Lack of sleep can amplify feelings of stress and anxiety. Whenever possible, try to rest when your baby is sleeping. Even short naps can make a difference. If you’re having trouble sleeping, consider simple relaxation techniques like deep breathing or listening to calming music before bed",
                style: TextStyle(fontSize: 16),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                "2. Nourish Your Body with Healthy Foods",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Tip Image with Padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust this padding as needed
              child: Image.asset(
                'assets/healthy_foods.jpg', // Replace with your image path
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "A balanced diet can significantly impact your mood. Try to include foods rich in protein, fiber, and healthy fats, such as lean meats, whole grains, fruits, and vegetables. Staying hydrated and avoiding too much caffeine can also help stabilize energy levels and reduce irritability.",
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Divider before comments
            const Divider(),

            // Comments Section Title
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Comments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Comments List
            if (comments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "No comments yet. Be the first to comment!",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              )
            else
              ...comments.map((comment) => CommentWidget(
                    comment: comment,
                    onReply: (reply) {
                      setState(() {
                        comment.replies.add(reply);
                      });
                    },
                    onThumbsUp: () {
                      setState(() {
                        comment.thumbsUp++;
                      });
                    },
                    onThumbsDown: () {
                      setState(() {
                        comment.thumbsDown++;
                      });
                    },
                  )),

            // Add Comment Section
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(hintText: 'Add a comment...'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}