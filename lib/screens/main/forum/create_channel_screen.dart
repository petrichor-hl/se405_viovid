import 'package:flutter/material.dart';
import 'package:viovid_app/features/channel/bloc/channel_cubit.dart';

class CreateChannelScreen extends StatefulWidget {
  final ChannelCubit channelCubit;

  const CreateChannelScreen({Key? key, required this.channelCubit})
      : super(key: key);

  @override
  _CreateChannelScreenState createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final TextEditingController _channelNameController = TextEditingController();
  final TextEditingController _channelDescriptionController =
      TextEditingController();

  void _createChannel() {
    final channelData = {
      'name': _channelNameController.text,
      'description': _channelDescriptionController.text,
    };

    print(
      "channel data: ${channelData}",
    );
    widget.channelCubit.createChannel(channelData);
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
              controller: _channelDescriptionController,
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
                        _channelDescriptionController.text.isNotEmpty) {
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
