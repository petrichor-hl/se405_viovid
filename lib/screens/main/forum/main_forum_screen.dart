import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/features/channel/bloc/channel_cubit.dart';
import 'package:viovid_app/features/channel/dtos/channel.dart';
import 'package:viovid_app/features/post/bloc/post_cubit.dart';
import 'package:viovid_app/features/post/post_api_service.dart';
import 'package:viovid_app/screens/main/forum/comment_page.dart';
import 'package:viovid_app/screens/main/forum/hashtag_topic_card.dart';
import 'package:viovid_app/screens/main/forum/create_post_screen.dart';
import 'package:viovid_app/screens/main/forum/post_card.dart';

class MainForumPage extends StatefulWidget {
  final Channel channel;
  final PostCubit postCubit;
  final ChannelCubit channelCubit;

  const MainForumPage({
    super.key,
    required this.channel,
    required this.postCubit,
    required this.channelCubit,
  });

  @override
  State<MainForumPage> createState() => _MainForumPageState();
}

class _MainForumPageState extends State<MainForumPage> {
  List<Channel> channels = [];
  Channel? currentChannel;

  List<Post> posts = [];
  Post? currentPost;

  bool isSubscribed = false;

  int _currentPostIndex = 0;

  PostCubit get postCubit => BlocProvider.of<PostCubit>(context);

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('MainForumPage init');
    _initialize();
  }

  void _initialize() async {
    currentChannel = widget.channel;
    print('Current channel: $currentChannel');
    await _getPostsForChannel(currentChannel!.id);
    await _checkSubscriptionStatus();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getPostsForChannel(String channelId) async {
    try {
      final fetchedPosts =
          await postCubit.getListPostFromChannel(_currentPostIndex, channelId);
      if (mounted) {
        setState(() {
          posts = fetchedPosts;
        });
      }
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

  Future<void> _checkSubscriptionStatus() async {
    if (currentChannel != null) {
      try {
        final userChannels = currentChannel!.userChannels;
        if (mounted) {
          setState(() {
            isSubscribed = userChannels.isNotEmpty;
          });
        }
      } catch (e) {
        print('Error checking subscription status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? _buildSkeletonLoading()
        : CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: HashtagTopicCard(
                  hashtag: currentChannel!.name,
                  description: currentChannel!.description,
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
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = posts[index];
                    return PostItem(
                      postData: post,
                      onCommentPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(
                              postCubit: postCubit,
                              postData: post,
                              onLikePressed: () => _onLikePressed(post),
                              onUnlikePressed: () => _onUnlikePressed(post),
                              onCommentPressed: () {},
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
          );
  }

  // Skeleton loading widget
  Widget _buildSkeletonLoading() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: HashtagTopicCard(
            hashtag: '',
            description: '',
            onCreatePost: () {},
          ),
        ),
        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //     child: Align(
        //       alignment: Alignment.centerRight,
        //       child: ElevatedButton.icon(
        //         onPressed: null,
        //         icon: const Icon(
        //           Icons.notifications_off,
        //           color: Colors.grey,
        //         ),
        //         label: const Text('Loading...'),
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.grey,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: SkeletonLoading(
                  height: 200,
                  width: double.infinity,
                ),
              );
            },
            childCount: 5, // Show 5 skeleton loading items
          ),
        ),
      ],
    );
  }
}
