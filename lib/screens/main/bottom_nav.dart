import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/cubits/app_bar_cubit.dart';
import 'package:viovid_app/screens/main/browse/browse.dart';
import 'package:viovid_app/screens/main/forum/forum.screen.dart';
import 'package:viovid_app/screens/main/noti_center/noti_center.screen.dart';
import 'package:viovid_app/screens/main/profile/profile.dart';

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
    NotifCenterScreen(),
    ProfileScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (ctx) => AppBarCubit(),
        child: _screens[_currentIndex],
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
