import 'package:flutter/material.dart';
import 'package:viovid_app/screens/main/forum/forum.screen.dart';

class CommentPage extends StatefulWidget {
  final Map<String, dynamic> postData;

  const CommentPage({required this.postData});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  late List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    // Initialize comments safely
    comments =
        List<Map<String, dynamic>>.from(widget.postData['comments'] ?? []);
  }

  void _addComment() {
    final newComment = {
      'id': 'c${comments.length + 1}',
      'userId': 'currentUser',
      'content': _commentController.text,
      'createAt': DateTime.now(),
    };

    setState(() {
      comments.add(newComment);
    });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ForumItem(
              postData: widget.postData,
              onCommentPressed: () {}, // No action required here
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return CommentItem(comment: comment);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      _addComment();
                    }
                  },
                  child: const Text('Post'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;

  const CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 8),
                Text(
                  comment['userId'],
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Text(
                  '${comment['createAt'].difference(DateTime.now()).inHours.abs()}h',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              comment['content'],
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
