import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:viovid_app/features/channel/dtos/channel.dart';
import 'package:viovid_app/features/post/bloc/post_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  final PostCubit postCubit;
  final VoidCallback onPostCreated;
  final Channel channel;

  const CreatePostScreen({
    required this.postCubit,
    required this.onPostCreated,
    required this.channel,
    super.key,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postContentController = TextEditingController();
  final List<File> _pickedImages = [];
  final ImagePicker _picker = ImagePicker();

  final StringTagController _stringTagController = StringTagController();

  final List<String> _initialTags = []; // Store hashtags

  void _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _pickedImages.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  void _createPost() async {
    final postData = {
      'content': _postContentController.text,
      'imageUrls': ['https://picsum.photos/200/300'],
      'hashtags': _stringTagController.getTags,
      'channelId': widget.channel.id,
    };

    print('Post data: $postData');

    await widget.postCubit.createPost(postData);
    widget.onPostCreated(); // Call the callback function

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _stringTagController.dispose();
    _postContentController.dispose();
    super.dispose();
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
              const Text(
                'Nhập hashtag bài đăng',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextFieldTags<String>(
                textfieldTagsController: _stringTagController,
                initialTags: _initialTags, // Set initial tags if any
                textSeparators: const [
                  ' ',
                  ','
                ], // Space or comma separates tags
                letterCase: LetterCase.normal, // Normalize letter case
                validator: (String tag) {
                  if (_stringTagController.getTags!.contains(tag)) {
                    return 'You\'ve already entered that';
                  }
                  return null;
                },
                inputFieldBuilder: (context, inputFieldValues) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      onTap: () {
                        // Request focus when the user taps the text field
                        _stringTagController.getFocusNode?.requestFocus();
                      },
                      controller: inputFieldValues.textEditingController,
                      focusNode: inputFieldValues.focusNode,
                      decoration: InputDecoration(
                        isDense: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 74, 137, 92),
                            width: 3.0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 74, 137, 92),
                            width: 3.0,
                          ),
                        ),
                        helperStyle: const TextStyle(
                          color: Color.fromARGB(255, 74, 137, 92),
                        ),
                        hintText: inputFieldValues.tags.isNotEmpty
                            ? ''
                            : "Enter tag...", // Display hint if no tags are entered
                        errorText: inputFieldValues.error,
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        prefixIcon: inputFieldValues.tags.isNotEmpty
                            ? SingleChildScrollView(
                                controller:
                                    inputFieldValues.tagScrollController,
                                scrollDirection: Axis.vertical,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    left: 8,
                                  ),
                                  child: Wrap(
                                    runSpacing: 4.0,
                                    spacing: 4.0,
                                    children:
                                        inputFieldValues.tags.map((String tag) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          color:
                                              Color.fromARGB(255, 74, 137, 92),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                '#$tag',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onTap: () {
                                                // You can handle tag tap here, e.g., navigate to another screen
                                              },
                                            ),
                                            const SizedBox(width: 4.0),
                                            InkWell(
                                              child: const Icon(
                                                Icons.cancel,
                                                size: 14.0,
                                                color: Color.fromARGB(
                                                    255, 233, 233, 233),
                                              ),
                                              onTap: () {
                                                // Remove the tag when the cancel icon is clicked
                                                inputFieldValues
                                                    .onTagRemoved(tag);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            : null,
                      ),
                      onChanged: inputFieldValues.onTagChanged,
                      onSubmitted: inputFieldValues.onTagSubmitted,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Nội dung bài đăng',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
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
                      final List<String> tags = _stringTagController.getTags!;
                      if (tags.isNotEmpty &&
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
                _createPost();
                Navigator.of(context).pop(); // Close dialog
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
}
