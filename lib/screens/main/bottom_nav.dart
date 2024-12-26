import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/cubits/app_bar_cubit.dart';
import 'package:viovid_app/features/post/bloc/post_cubit.dart';
import 'package:viovid_app/features/post/data/post_repository.dart';
import 'package:viovid_app/features/post/post_api_service.dart';
import 'package:viovid_app/features/topic/cubit/topic_list_cubit.dart';
import 'package:viovid_app/features/topic/data/topic_list_api_service.dart';
import 'package:viovid_app/features/topic/data/topic_list_repository.dart';
import 'package:viovid_app/helpers/notification_helper.dart';
import 'package:viovid_app/screens/main/browse/browse.screen.dart';
import 'package:viovid_app/features/channel/bloc/channel_cubit.dart';
import 'package:viovid_app/features/channel/channel_api_service.dart';
import 'package:viovid_app/features/channel/data/channel_repository.dart';
import 'package:viovid_app/screens/main/forum/forum.screen.dart';
import 'package:viovid_app/screens/main/noti_center/noti_center.screen.dart';
import 'package:viovid_app/screens/main/profile/profile.screen.dart';

const Map<String, IconData> _icons = {
  'Trang chủ': Icons.home_rounded,
  'Forum': Icons.forum_rounded,
  'Thông báo': Icons.notifications_rounded,
  'Hồ sơ': Icons.account_box,
};

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List<Widget> _screens = const [
    BrowseScreen(
      key: PageStorageKey('BrowseScreen'),
    ),
    ForumScreen(
      key: PageStorageKey('ForumScreen'),
    ),
    NotiCenterScreen(),
    ProfileScreen(),
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    NotificationHelper().initNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => AppBarCubit(),
          ),
          BlocProvider(
            create: (ctx) => TopicListCubit(
              TopicListRepository(
                topicApiService: TopicListApiService(dio),
              ),
            ),
          ),
          // BlocProvider(
          //   create: (ctx) => NotiCenterCubit(
          //     NotiCenterRepository(
          //       notiCenterApiService: NotiCenterApiService(dio),
          //     ),
          //   ),
          // ),
          BlocProvider<ChannelCubit>(
            create: (ctx) => ChannelCubit(
              ChannelRepository(ChannelApiService(dio)),
            ),
          ),
          BlocProvider<PostCubit>(
            create: (ctx) => PostCubit(
              PostRepository(PostApiService(dio)),
            ),
          ),
        ],
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor,
        items: _icons.entries
            .map(
              (e) => BottomNavigationBarItem(
                icon: Icon(
                  e.value,
                  size: 28,
                ),
                label: e.key,
              ),
            )
            .toList(),
        onTap: (value) => setState(() {
          _currentIndex = value;
        }),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
      ),
    );
  }
}
