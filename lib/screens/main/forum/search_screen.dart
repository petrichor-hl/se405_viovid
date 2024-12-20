import 'package:flutter/material.dart';
import 'package:viovid_app/features/channel/bloc/channel_cubit.dart';
import 'package:viovid_app/features/channel/channel_api_service.dart';

class SearchChannelScreen extends StatefulWidget {
  final ChannelCubit channelCubit;
  final void Function(Channel channel) onChannelSelected;

  const SearchChannelScreen(
      {Key? key, required this.channelCubit, required this.onChannelSelected})
      : super(key: key);

  @override
  _SearchScreenChannelState createState() => _SearchScreenChannelState();
}

class _SearchScreenChannelState extends State<SearchChannelScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Channel> _channels = [];
  int _currentChannelIndex = 0;
  bool _isSearching = false;

  Future<void> _getChannels() async {
    try {
      setState(() {
        _isSearching = true;
      });
      final fetchedChannels = await widget.channelCubit
          .getListChannel(_currentChannelIndex, _searchController.text);
      if (mounted) {
        setState(() {
          _channels = fetchedChannels;
          _isSearching = false;
        });
      }
    } catch (e) {
      print('Error fetching channels: $e');
    }
  }

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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Tìm kiếm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _getChannels,
                  child: const Text('Tìm kiếm'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isSearching) const CircularProgressIndicator(),
            if (!_isSearching && _channels.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _channels.length,
                  itemBuilder: (context, index) {
                    final channel = _channels[index];
                    return ListTile(
                      title: Text(
                        channel.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => {
                          widget.onChannelSelected(channel),
                          Navigator.pop(context)
                        },
                        child: const Text('Chọn'),
                      ),
                    );
                  },
                ),
              ),
            if (!_isSearching &&
                _channels.isEmpty &&
                _searchController.text.isNotEmpty)
              const Text(
                'Không tìm thấy kênh nào.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
