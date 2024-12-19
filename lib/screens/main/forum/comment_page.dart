import 'package:flutter/material.dart';
import 'package:viovid_app/features/post/bloc/post_cubit.dart';
import 'package:viovid_app/features/post/post_api_service.dart';
import 'package:viovid_app/screens/main/forum/forum.screen.dart';

class CommentPage extends StatefulWidget {
  final PostCubit postCubit;
  final Post postData;
  final VoidCallback onLikePressed;
  final VoidCallback onUnlikePressed;
  final VoidCallback onCommentPressed;

  const CommentPage({
    required this.postCubit,
    required this.postData,
    required this.onLikePressed,
    required this.onUnlikePressed,
    required this.onCommentPressed,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  late List<PostComment> comments = [];
  int _currentCommentIndex = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _getCommentsForPost(widget.postData.id);
  }

  Future<void> _getCommentsForPost(String postId) async {
    try {
      final fetchedComments =
          await widget.postCubit.listComments(_currentCommentIndex, postId);

      print(fetchedComments);
      setState(() {
        comments = fetchedComments;
      });
    } catch (e) {
      print('Error fetching posts for comments: $e');
    }
  }

  void _addComment() async {
    var postData = {
      'postId': widget.postData.id,
      'content': _commentController.text,
    };

    _commentController.clear();
    await widget.postCubit.addComment(postData);
    _getCommentsForPost(widget.postData.id);
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
              onCommentPressed: () {},
              onLikePressed: widget.onLikePressed,
              onUnlikePressed: widget.onUnlikePressed,
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
                    style: const TextStyle(color: Colors.white),
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
  final PostComment comment;

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
                  comment.applicationUser['userName'],
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Spacer(),
                Text(
                  '${comment.createdAt.difference(DateTime.now()).inHours.abs()}h',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              comment.content,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
