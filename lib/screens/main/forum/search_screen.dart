import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _channels = [];
  bool _isSearching = false;

  void _performSearch() {
    setState(() {
      _isSearching = true;

      // Simulate search results
      _channels = [
        'Channel 1',
        'Channel 2',
        'Channel 3',
        'Channel 4',
      ]
          .where((channel) => channel
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();

      _isSearching = false;
    });
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
                  onPressed: _performSearch,
                  child: const Text('Tìm kiếm'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('#Cận đây')),
                Chip(label: Text('#Kinh dị')),
                Chip(label: Text('#Du lịch')),
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
                        channel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã theo dõi $channel')),
                          );
                        },
                        child: const Text('Theo dõi'),
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
