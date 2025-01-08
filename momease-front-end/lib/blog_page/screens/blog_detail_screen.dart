import 'package:flutter/material.dart';
import 'package:front_end/blog_page/models/blog_model.dart';
import 'package:front_end/blog_page/widgets/comment_widget.dart';

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
          userImageUrl: 'https://via.placeholder.com/40', // Placeholder image URL
          username: 'User', // Replace with actual username if available
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
            Image.asset(widget.blog.imagePath, fit: BoxFit.cover),

            // Blog Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.blog.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Blog Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.blog.content,
                style: const TextStyle(fontSize: 16),
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
                  // Comment Text Field
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(hintText: 'Add a comment...'),
                    ),
                  ),

                  // Send Button
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
