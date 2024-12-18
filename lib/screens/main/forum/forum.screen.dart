import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/features/channel/bloc/channel_cubit.dart';
import 'package:viovid_app/features/channel/channel_api_service.dart';
import 'package:viovid_app/features/channel/data/channel_repository.dart';
import 'package:viovid_app/features/post/bloc/post_cubit.dart';
import 'package:viovid_app/features/post/data/post_repository.dart';
import 'package:viovid_app/features/post/post_api_service.dart';
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
  List<Channel> channels = [];
  Channel? currentChannel;

  List<Post> posts = [];
  Post? currentPost;

  int _currentPostIndex = 0;
  int _currentChannelIndex = 0;

  ChannelCubit get channelCubit => BlocProvider.of<ChannelCubit>(context);
  PostCubit get postCubit => BlocProvider.of<PostCubit>(context);

  @override
  void initState() {
    super.initState();
    print('Forum screen init');
    _initialize();
  }

  void _initialize() async {
    await _getChannels();
    await _getPostsForChannel(currentChannel?.id ?? '');
  }

  Future<void> _getChannels() async {
    try {
      final fetchedChannels =
          await channelCubit.getListChannel(_currentChannelIndex);
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

  Future<void> _getPosts() async {
    try {
      final fetchedPosts = await postCubit.getListPost(_currentPostIndex);
      print('Fetched posts: $fetchedPosts');
      setState(() {
        posts = fetchedPosts;
        currentPost = fetchedPosts.isNotEmpty ? fetchedPosts.first : null;
      });
    } catch (e) {
      print('Error fetching channels: $e');
    }
  }

  Future<void> _getPostsForChannel(String channelId) async {
    try {
      final fetchedPosts =
          await postCubit.getListPostFromChannel(_currentPostIndex, channelId);
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print('Error fetching posts for channel: $e');
    }
  }

  void _onChannelTap(Channel channel) {
    setState(() {
      currentChannel = channel;
    });
    _getPostsForChannel(channel.id);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChannelCubit>(
          create: (context) => ChannelCubit(
            ChannelRepository(ChannelApiService(dio)),
          ),
        ),
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            PostRepository(PostApiService(dio)),
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
              HashtagTopicCard(
                hashtag: currentChannel?.name ?? 'No channel selected',
                description:
                    currentChannel?.description ?? 'No description available',
                onCreatePost: () {
                  final postCubit = context.read<PostCubit>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreatePostScreen(
                        postCubit: postCubit,
                        channel: currentChannel!,
                        onPostCreated: () =>
                            _getPostsForChannel(currentChannel!.id),
                      ),
                    ),
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
  final Post postData;
  final VoidCallback onCommentPressed;

  const ForumItem({
    required this.postData,
    required this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    print("postData.imageUrls.isNotEmpty: ${postData.imageUrls.isNotEmpty}");
    print("postData.imageUrls.isNotEmpty: ${postData.imageUrls.length}");
    print("postData.imageUrls runtimeType: ${postData.imageUrls.runtimeType}");
    print("postData.imageUrls raw: ${postData.imageUrls}");

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8.0, // Space between tags
              runSpacing: 4.0, // Space between lines of tags
              children: postData.hashtags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    '#$tag',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 8),
                Expanded(
                  flex: 8, // 80% of the available width
                  child: Text(
                    (postData.applicationUser)["userName"],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Text(
                  '${postData.createdAt.difference(DateTime.now()).inHours.abs()}h',
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis, // Handle overflow
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              postData.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (postData.imageUrls.isNotEmpty)
              Image.network(
                postData.imageUrls.first,
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
                Text('${postData.likes}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: onCommentPressed,
                ),
                Text('${postData.comments.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
