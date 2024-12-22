import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/features/channel/bloc/channel_cubit.dart';

class CreateChannelScreen extends StatefulWidget {
  final ChannelCubit channelCubit;
  final VoidCallback onChannelCreated;

  const CreateChannelScreen({
    super.key,
    required this.channelCubit,
    required this.onChannelCreated,
  });

  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final TextEditingController _channelNameController = TextEditingController();
  final TextEditingController _channelDescriptionController =
      TextEditingController();

  void _createChannel() async {
    final channelData = {
      'name': _channelNameController.text,
      'description': _channelDescriptionController.text,
    };

    print(
      "channel data: ${channelData}",
    );
    await widget.channelCubit.createChannel(channelData);
    widget.onChannelCreated(); // Call the callback function
    Navigator.pop(context);
  }

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
                _createChannel();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(const Duration(milliseconds: 300));
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tên kênh',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              const Gap(8),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: _channelNameController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 51, 51, 51),
                  hintText: 'VD: #violet_evergarden',
                  hintStyle: TextStyle(color: Color(0xFFACACAC)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nội dung kênh',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const Gap(8),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: _channelDescriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 51, 51, 51),
                  hintText: 'Nhập nội dung kênh',
                  hintStyle: TextStyle(color: Color(0xFFACACAC)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                ),
              ),
              const Gap(16),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the screen
                    },
                    child: const Text(
                      'Huỷ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (_channelNameController.text.isNotEmpty &&
                          _channelDescriptionController.text.isNotEmpty) {
                        _showConfirmationDialog();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Vui lòng nhập đầy đủ thông tin.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Đồng ý',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
