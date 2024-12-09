import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
