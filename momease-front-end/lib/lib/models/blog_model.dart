class Blog {
  final String title;
  final String imagePath;
  final String content;

  Blog({
    required this.title,
    required this.imagePath,
    required this.content,
  });
}

class Comment {
  final String content;
  final String userImageUrl;
  final String username;
  DateTime timestamp;
  List<Comment> replies;
  int thumbsUp;
  int thumbsDown;

  Comment({
    required this.content,
    required this.userImageUrl,
    required this.username,
    required this.timestamp,
    this.replies = const [],
    this.thumbsUp = 0,
    this.thumbsDown = 0,
  });
}
