import 'package:flutter/material.dart';

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
  // Use the mock data
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
                onTap: () {},
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
                print('Tạo bài đăng pressed');
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

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('#Cận đây')),
                Chip(label: Text('#Kinh dị')),
                Chip(label: Text('#Du lịch')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hashtag,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onCreatePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Tạo bài đăng',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentPage extends StatefulWidget {
  final Map<String, dynamic> postData;

  const CommentPage({required this.postData});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    final newComment = {
      'id': 'c${widget.postData['comments'].length + 1}',
      'userId': 'currentUser',
      'content': _commentController.text,
      'createAt': DateTime.now(),
    };

    setState(() {
      widget.postData['comments'].add(newComment);
    });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final comments = widget.postData['comments'] as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.postData['content'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(comment['userId']),
                  subtitle: Text(comment['content']),
                  trailing: Text(
                    '${comment['createAt'].difference(DateTime.now()).inHours.abs()}h',
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
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
