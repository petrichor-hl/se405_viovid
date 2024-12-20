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
  Map<String, bool> subscriptionStatus = {};

  List<Post> posts = [];
  Post? currentPost;

  bool isSubscribed = false;

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
    await _getChannelsByUser();
    await _getPostsForChannel(currentChannel?.id ?? '');
    await _checkSubscriptionStatus();
  }

  // Future<void> _getChannels() async {
  //   try {
  //     final fetchedChannels =
  //         await channelCubit.getListChannel(_currentChannelIndex);
  //     print('Fetched channels: $fetchedChannels');
  //     setState(() {
  //       channels = fetchedChannels;
  //       currentChannel =
  //           fetchedChannels.isNotEmpty ? fetchedChannels.first : null;
  //     });
  //   } catch (e) {
  //     print('Error fetching channels: $e');
  //   }
  // }

  Future<void> _getChannelsByUser() async {
    try {
      final fetchedChannels =
          await channelCubit.getListChannelByUser(_currentChannelIndex);
      setState(() {
        channels = fetchedChannels;
        currentChannel =
            fetchedChannels.isNotEmpty ? fetchedChannels.first : null;
        // Initialize subscription status for each channel
        for (var channel in channels) {
          final userChannels = channel!.userChannels;
          subscriptionStatus[channel.id] = userChannels.isNotEmpty;
        }
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

  Future<void> _likePost(String postId) async {
    try {
      await postCubit.likePost(postId);
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  Future<void> _unlikePost(String postId) async {
    try {
      await postCubit.unlikePost(postId);
    } catch (e) {
      print('Error unliking post: $e');
    }
  }

  void _onLikePressed(Post post) async {
    setState(() {
      post.likes += 1;
    });

    try {
      await _likePost(post.id);
    } catch (e) {
      print('Error liking post: $e');
      setState(() {
        post.likes -= 1;
      });
    }
  }

  void _onUnlikePressed(Post post) async {
    setState(() {
      post.likes -= 1;
    });

    try {
      await _unlikePost(post.id);
    } catch (e) {
      print('Error unliking post: $e');
      setState(() {
        post.likes += 1;
      });
    }
  }

  // Check subscription status of the current user for the channel
  Future<void> _checkSubscriptionStatus() async {
    if (currentChannel != null) {
      try {
        final userChannels = currentChannel!.userChannels;
        setState(() {
          isSubscribed = userChannels.isNotEmpty;
        });
      } catch (e) {
        print('Error checking subscription status: $e');
      }
    }
  }

  Future<void> _toggleSubscription(Channel channel) async {
    print("subscriptionStatus: $subscriptionStatus");
    if (channel == null) return;

    var payload = {
      'channelId': channel.id,
    };

    try {
      if (subscriptionStatus[channel.id] == true) {
        await channelCubit.unsubscribeChannel(payload);
      } else {
        await channelCubit.subscribeChannel(payload);
      }

      setState(() {
        subscriptionStatus[channel.id] = !subscriptionStatus[channel.id]!;

        if (currentChannel != null && currentChannel!.id == channel.id) {
          isSubscribed = subscriptionStatus[channel.id]!;
        }
      });
    } catch (e) {
      print('Error toggling subscription: $e');
    }
  }

  void _onChannelTap(Channel channel) async {
    setState(() {
      currentChannel = channel;
    });
    await _getPostsForChannel(channel.id);
    await _checkSubscriptionStatus();
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
                          onChannelCreated: _getChannelsByUser,
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
                    trailing: ElevatedButton.icon(
                      onPressed: () => _toggleSubscription(channel),
                      icon: Icon(
                        subscriptionStatus[channel.id] == true
                            ? Icons.notifications_off
                            : Icons.notifications_on,
                        color: subscriptionStatus[channel.id] == true
                            ? Colors.grey
                            : Colors.blue,
                      ),
                      label: Text(
                        subscriptionStatus[channel.id] == true
                            ? 'Unsubscribe'
                            : 'Subscribe',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: subscriptionStatus[channel.id] == true
                            ? Colors.grey
                            : Colors.blue,
                      ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HashtagTopicCard(
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => _toggleSubscription(currentChannel!),
                    icon: Icon(
                      isSubscribed
                          ? Icons.notifications_off
                          : Icons.notifications_on,
                      color: isSubscribed ? Colors.grey : Colors.blue,
                    ),
                    label: Text(
                      isSubscribed ? 'Unsubscribe' : 'Subscribe',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSubscribed ? Colors.grey : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = posts[index];
                  return ForumItem(
                    postData: post,
                    onCommentPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(
                            postCubit: postCubit,
                            postData: post,
                            onCommentPressed: () {},
                            onLikePressed: () => _onLikePressed(post),
                            onUnlikePressed: () => _onUnlikePressed(post),
                          ),
                        ),
                      );
                    },
                    onLikePressed: () => _onLikePressed(post),
                    onUnlikePressed: () => _onUnlikePressed(post),
                  );
                },
                childCount: posts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForumItem extends StatelessWidget {
  final Post postData;
  final VoidCallback onLikePressed;
  final VoidCallback onUnlikePressed;
  final VoidCallback onCommentPressed;

  const ForumItem({
    required this.postData,
    required this.onLikePressed,
    required this.onUnlikePressed,
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
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
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
                  flex: 8,
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
                  overflow: TextOverflow.ellipsis,
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
                  icon: postData.likes > 0
                      ? const Icon(Icons.thumb_up, color: Colors.blue)
                      : const Icon(Icons.thumb_up_alt_outlined),
                  onPressed:
                      postData.likes > 0 ? onUnlikePressed : onLikePressed,
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
