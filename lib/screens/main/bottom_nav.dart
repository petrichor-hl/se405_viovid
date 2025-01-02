import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/cubits/app_bar_cubit.dart';
import 'package:viovid_app/features/topic/cubit/topic_list_cubit.dart';
import 'package:viovid_app/features/topic/data/topic_list_api_service.dart';
import 'package:viovid_app/features/topic/data/topic_list_repository.dart';
import 'package:viovid_app/helpers/notification_helper.dart';
import 'package:viovid_app/screens/main/browse/browse.screen.dart';
import 'package:viovid_app/screens/main/noti_center/noti_center.screen.dart';
import 'package:viovid_app/screens/main/profile/profile.screen.dart';

const Map<String, IconData> _icons = {
  'Trang chủ': Icons.home_rounded,
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
