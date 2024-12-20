import 'package:flutter/material.dart';
import 'package:viovid_app/features/post/post_api_service.dart';

class PostItem extends StatefulWidget {
  final Post postData;
  final VoidCallback onLikePressed;
  final VoidCallback onUnlikePressed;
  final VoidCallback onCommentPressed;

  const PostItem({
    required this.postData,
    required this.onLikePressed,
    required this.onUnlikePressed,
    required this.onCommentPressed,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool likeStatus = false;

  void _toggleLike() {
    setState(() {
      likeStatus = !likeStatus;
    });

    if (likeStatus) {
      widget.onLikePressed();
    } else {
      widget.onUnlikePressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.postData.hashtags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    '#$tag',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 8),
                Expanded(
                  flex: 8,
                  child: Text(
                    (widget.postData.applicationUser)["userName"],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.postData.createdAt.difference(DateTime.now()).inHours.abs()}h',
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.postData.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (widget.postData.imageUrls.isNotEmpty)
              Image.network(
                widget.postData.imageUrls.first,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: likeStatus
                      ? const Icon(Icons.thumb_up, color: Colors.blue)
                      : const Icon(Icons.thumb_up_alt_outlined),
                  onPressed: _toggleLike,
                ),
                Text('${widget.postData.likes}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: widget.onCommentPressed,
                ),
                Text('${widget.postData.comments.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
