import 'package:flutter/material.dart';
import 'package:blogpage/models/blog_model.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final Function(Comment) onReply;
  final VoidCallback onThumbsUp;
  final VoidCallback onThumbsDown;

  const CommentWidget({
    Key? key,
    required this.comment,
    required this.onReply,
    required this.onThumbsUp,
    required this.onThumbsDown,
  }) : super(key: key);

  void _reply(BuildContext context) {
    final TextEditingController _replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reply to Comment'),
          content: TextField(
            controller: _replyController,
            decoration: InputDecoration(hintText: 'Type your reply here...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_replyController.text.isNotEmpty) {
                  final newReply = Comment(
                    content: _replyController.text,
                    userImageUrl: 'https://via.placeholder.com/40',
                    username: 'User',
                    timestamp: DateTime.now(),
                    thumbsUp: 0,
                    thumbsDown: 0,
                  );
                  onReply(newReply);
                  Navigator.pop(context);
                }
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  String _timeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.userImageUrl),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(comment.username, style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_timeAgo(comment.timestamp), style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    Text(comment.content),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: onThumbsUp,
                        ),
                        Text('${comment.thumbsUp}'),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: onThumbsDown,
                        ),
                        Text('${comment.thumbsDown}'),
                        IconButton(
                          icon: Icon(Icons.reply),
                          onPressed: () => _reply(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          for (var reply in comment.replies)
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: CommentWidget(
                comment: reply,
                onReply: onReply,
                onThumbsUp: onThumbsUp,
                onThumbsDown: onThumbsDown,
              ),
            ),
        ],
      ),
    );
  }
}
