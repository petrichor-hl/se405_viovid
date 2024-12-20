import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/channel/bloc/channel_cubit.dart';
import 'package:viovid_app/features/channel/channel_api_service.dart';
import 'package:viovid_app/features/post/bloc/post_cubit.dart';
import 'package:viovid_app/screens/main/forum/create_channel_screen.dart';
import 'package:viovid_app/screens/main/forum/main_forum_screen.dart';
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
  bool isSubscribed = false;

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
  }

  Future<void> _getChannelsByUser() async {
    try {
      final fetchedChannels =
          await channelCubit.getListChannelByUser(_currentChannelIndex);
      setState(() {
        channels = fetchedChannels;
        currentChannel =
            fetchedChannels.isNotEmpty ? fetchedChannels.first : null;
        for (var channel in channels) {
          final userChannels = channel!.userChannels;
          subscriptionStatus[channel.id] = userChannels.isNotEmpty;
        }
      });
    } catch (e) {
      print('Error fetching channels: $e');
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

  Future<void> _updateSubscriptionStatus(
      Channel channel, bool subscribed) async {
    if (subscriptionStatus[channel.id] == null) {
      channels.add(channel);
    }
    setState(() {
      subscriptionStatus[channel.id] = subscribed;

      if (currentChannel != null && currentChannel!.id == channel.id) {
        isSubscribed = subscribed;
      }
    });
  }

  void _onChannelTap(Channel channel) async {
    print('Channel tapped: ${channel.name}');
    var channelDetail = await channelCubit.getChannelById(channel.id);

    if (channelDetail != null) {
      setState(() {
        currentChannel = channelDetail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    style: const TextStyle(color: Colors.white),
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
                MaterialPageRoute(
                    builder: (context) => SearchChannelScreen(
                          channelCubit: channelCubit,
                          onChannelSelected: _onChannelTap,
                        )),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _getChannelsByUser, // Trigger a refresh when pulled down
        child: currentChannel != null
            ? MainForumPage(
                key: ValueKey(currentChannel!.id),
                channel: currentChannel!,
                channelCubit: channelCubit,
                postCubit: postCubit,
                onSubscriptionChanged: (channel, subscribed) {
                  _updateSubscriptionStatus(channel, subscribed);
                },
              )
            : ListView(
                // Ensure the RefreshIndicator works even with no content
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No channel selected'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
