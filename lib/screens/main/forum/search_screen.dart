// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:viovid_app/features/channel/bloc/channel_cubit.dart';
import 'package:viovid_app/features/channel/dtos/channel.dart';

class SearchChannelScreen extends StatefulWidget {
  final ChannelCubit channelCubit;
  final void Function(Channel channel) onChannelSelected;

  const SearchChannelScreen({
    super.key,
    required this.channelCubit,
    required this.onChannelSelected,
  });

  @override
  State<SearchChannelScreen> createState() => _SearchScreenChannelState();
}

class _SearchScreenChannelState extends State<SearchChannelScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Channel> _channels = [];
  int _currentChannelIndex = 0;
  bool _isSearching = false;

  Future<void> _getChannels() async {
    FocusScope.of(context).unfocus();
    if (_searchController.text.isEmpty) {
      return;
    }

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
        title: const Text('Tìm kiếm kênh'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(const Duration(milliseconds: 300));
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 51, 51, 51),
                      hintText: 'Nhập mã kênh',
                      hintStyle: TextStyle(color: Color(0xFFACACAC)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onEditingComplete: _getChannels,
                  ),
                ),
                IconButton.filled(
                  onPressed: _getChannels,
                  icon: const Icon(Icons.search),
                  style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      )),
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
                    return InkWell(
                      onTap: () {
                        widget.onChannelSelected(channel);
                        Navigator.pop(context, {
                          'closeDrawer': true,
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '#${channel.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.grey,
                            )
                          ],
                        ),
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
