import 'package:flutter/material.dart';

class HashtagTopicCard extends StatelessWidget {
  final String hashtag;
  final String description;
  final VoidCallback onCreatePost;

  const HashtagTopicCard({
    super.key,
    required this.hashtag,
    required this.description,
    required this.onCreatePost,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#$hashtag',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              FilledButton(
                onPressed: onCreatePost,
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  spacing: 8,
                  children: [
                    Text('Tạo bài đăng'),
                    Icon(
                      Icons.add_rounded,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
