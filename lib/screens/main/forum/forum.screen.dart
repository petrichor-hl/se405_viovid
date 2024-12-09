import 'package:flutter/material.dart';
import 'package:viovid_app/screens/main/forum/comment_page.dart';
import 'package:viovid_app/screens/main/forum/create_channel_screen.dart';
import 'package:viovid_app/screens/main/forum/create_post_screen.dart';
import 'package:viovid_app/screens/main/forum/hashtag_topic_card.dart';
import 'package:viovid_app/screens/main/forum/search_screen.dart';

final List<Map<String, dynamic>> mockPosts = [
  {
    'id': '1',
    'userId': 'user1',
    'like': 120,
    'content': 'Một đặc vụ FBI quyết tâm truy bắt một kẻ lừa đảo...',
    'imageUrl': 'https://via.placeholder.com/400x200',
    'hashtags': ['#scene', '#bcdeptrai'],
    'createAt': DateTime.now().subtract(const Duration(hours: 3)),
    'updateAt': DateTime.now(),
    'comments': [
      {
        'id': 'c1',
        'userId': 'user2',
        'content': 'Thật sự rất thú vị!',
        'createAt': DateTime.now().subtract(const Duration(hours: 2)),
      },
    ],
  },
  {
    'id': '2',
    'userId': 'user3',
    'like': 199,
    'content': 'Phong cảnh đẹp đến ngỡ ngàng...',
    'imageUrl': 'https://via.placeholder.com/400x200',
    'hashtags': ['#travel', '#nature'],
    'createAt': DateTime.now().subtract(const Duration(hours: 5)),
    'updateAt': DateTime.now(),
    'comments': [
      {
        'id': 'c2',
        'userId': 'user4',
        'content': 'Quá đẹp, tôi muốn đến đây!',
        'createAt': DateTime.now().subtract(const Duration(hours: 4)),
      },
      {
        'id': 'c3',
        'userId': 'user5',
        'content': 'Nhìn là thấy yên bình.',
        'createAt':
            DateTime.now().subtract(const Duration(hours: 3, minutes: 30)),
      },
    ],
  },
];

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final List<Map<String, dynamic>> posts = mockPosts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              ListTile(
                title: const Text(
                  'Kênh bạn theo dõi',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.white),
                title: const Text(
                  'Tạo kênh mới',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateChannelScreen()),
                  );
                },
              ),
              const Divider(color: Colors.white),
              ListTile(
                title: const Text(
                  'Tất cả các kênh',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const CircleAvatar(child: Text('C')),
                title: const Text(
                  'Viovid',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Forum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HashtagTopicCard(
              hashtag: '#viovid',
              description:
                  'Kênh mặc định của Viovid, hiển các thông báo mới nhất của phát hành',
              onCreatePost: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePostScreen()),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return ForumItem(
                    postData: posts[index],
                    onCommentPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(
                            postData: posts[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForumItem extends StatelessWidget {
  final Map<String, dynamic> postData;

  final VoidCallback onCommentPressed;

  const ForumItem({
    required this.postData,
    required this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postData['hashtags'].join(' '),
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 8),
                Text(postData['userId'], style: const TextStyle(fontSize: 16)),
                const Spacer(),
                Text(
                  '${postData['createAt'].difference(DateTime.now()).inHours.abs()}h',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              postData['content'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Image.network(
              postData['imageUrl'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_alt_outlined),
                  onPressed: () {},
                ),
                Text('${postData['like']}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: onCommentPressed,
                ),
                Text('${postData['comments'].length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
