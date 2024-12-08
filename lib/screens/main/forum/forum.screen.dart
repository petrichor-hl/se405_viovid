import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

class CreateChannelScreen extends StatefulWidget {
  @override
  _CreateChannelScreenState createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final TextEditingController _channelNameController = TextEditingController();
  final TextEditingController _channelContentController =
      TextEditingController();

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn tạo kênh này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Huỷ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Handle channel creation logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kênh đã được tạo thành công!')),
                );
              },
              child: const Text('Đồng ý'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Kênh Mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tên kênh',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _channelNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập tên kênh',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Nội dung kênh',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _channelContentController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập nội dung kênh',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the screen
                  },
                  child: const Text('Huỷ'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_channelNameController.text.isNotEmpty &&
                        _channelContentController.text.isNotEmpty) {
                      _showConfirmationDialog();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vui lòng nhập đầy đủ thông tin.')),
                      );
                    }
                  },
                  child: const Text('Đồng ý'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postTitleController = TextEditingController();
  final TextEditingController _postContentController = TextEditingController();
  final List<File> _pickedImages = [];

  final ImagePicker _picker = ImagePicker();

  void _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _pickedImages.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn tạo bài đăng này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Huỷ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Handle post creation logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Bài đăng đã được tạo thành công!')),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Đồng ý'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Bài Đăng Mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tiêu đề bài đăng',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 8),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: _postTitleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập tiêu đề bài đăng',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Nội dung bài đăng',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 8),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: _postContentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập nội dung bài đăng',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Thêm hình ảnh'),
              ),
              const SizedBox(height: 16),
              // Display selected images
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _pickedImages
                    .map((image) => Stack(
                          children: [
                            Image.file(
                              image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pickedImages.remove(image);
                                  });
                                },
                                child:
                                    const Icon(Icons.close, color: Colors.red),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Huỷ'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_postTitleController.text.isNotEmpty &&
                          _postContentController.text.isNotEmpty) {
                        _showConfirmationDialog();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Vui lòng nhập đầy đủ thông tin.')),
                        );
                      }
                    },
                    child: const Text('Đồng ý'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
