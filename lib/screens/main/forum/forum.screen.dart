import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/features/channel/bloc/channel_cubit.dart';
import 'package:viovid_app/features/channel/channel_api_service.dart';
import 'package:viovid_app/features/channel/data/channel_repository.dart';
import 'package:viovid_app/screens/main/forum/comment_page.dart';
import 'package:viovid_app/screens/main/forum/create_channel_screen.dart';
import 'package:viovid_app/screens/main/forum/create_post_screen.dart';
import 'package:viovid_app/screens/main/forum/hashtag_topic_card.dart';
import 'package:viovid_app/screens/main/forum/search_screen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  late List<Map<String, dynamic>> posts = [];
  List<Channel> channels = [];
  Channel? currentChannel;

  ChannelCubit get channelCubit => BlocProvider.of<ChannelCubit>(context);

  @override
  void initState() {
    super.initState();
    print('Forum screen init');
    _getChannels();
  }

  Future<void> _getChannels() async {
    try {
      final fetchedChannels = await channelCubit.getListChannel();
      print('Fetched channels: $fetchedChannels');
      setState(() {
        channels = fetchedChannels;
        currentChannel =
            fetchedChannels.isNotEmpty ? fetchedChannels.first : null;
      });
    } catch (e) {
      print('Error fetching channels: $e');
    }
  }

  // Future<void> _getPostsForChannel(String channelId) async {
  //   _logger.info('Fetching posts for channel $channelId...');
  //   try {
  //     // Replace this with the actual API call to fetch posts for the channel
  //     final fetchedPosts = await channelCubit.getPostsForChannel(channelId);
  //     _logger.info('Fetched posts: $fetchedPosts');
  //     setState(() {
  //       posts = fetchedPosts;
  //     });
  //   } catch (e) {
  //     _logger.severe('Error fetching posts: $e');
  //   }
  // }

  void _onChannelTap(Channel channel) {
    setState(() {
      currentChannel = channel;
    });
    // _getPostsForChannel(channel['id']);
  }

  @override
  Widget build(BuildContext context) {
    print('ForumScreen build called');
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChannelCubit>(
          create: (context) => ChannelCubit(
            ChannelRepository(ChannelApiService(dio)),
          ),
        ),
      ],
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            color: Colors.black,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.add, color: Colors.white),
                  title: const Text(
                    'Tạo kênh mới',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    final channelCubit = context.read<ChannelCubit>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateChannelScreen(
                          channelCubit: channelCubit,
                          onChannelCreated: _getChannels,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.white),
                ListTile(
                  title: const Text(
                    'Kênh bạn theo dõi',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onTap: () {},
                ),
                ...channels.map((channel) {
                  return ListTile(
                    leading: CircleAvatar(child: Text(channel.name[0])),
                    title: Text(
                      channel.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      _onChannelTap(channel);
                    },
                  );
                }).toList(),
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
              if (currentChannel != null) ...[
                Text(
                  currentChannel!.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(currentChannel!.description),
              ],
              HashtagTopicCard(
                hashtag: currentChannel?.name ?? 'No channel selected',
                description:
                    currentChannel?.description ?? 'No description available',
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
