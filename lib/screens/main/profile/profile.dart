import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:viovid_app/screens/main/profile/components/profile_header.dart';
import 'package:viovid_app/screens/main/profile/components/profile_setting_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // void _clearGlobalDataOfUser() {
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const ProfileHeader(),
          ProfileSettingItem(
            title: 'Thông tin tài khoản',
            iconData: Icons.account_box,
            onTap: () {},
          ),
          ProfileSettingItem(
            title: 'Đổi mật khẩu',
            iconData: Icons.password_rounded,
            onTap: () {},
          ),
          ProfileSettingItem(
            title: 'Tải xuống',
            iconData: Icons.list,
            onTap: () {},
          ),
          const Spacer(),
          FilledButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Đăng xuất'),
                  content: const Text('Bạn có chắc muốn tiếp tục?'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.white,
                  actions: [
                    TextButton(
                      onPressed: () async {
                        // try {
                        //   await supabase.auth.signOut();
                        // } catch (error) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //         content: Text(
                        //             'Có lỗi xảy ra, đăng xuất thất bại')),
                        //   );
                        // }
                      },
                      child: const Text('Có'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Huỷ'),
                    )
                  ],
                ),
              );
            },
            child: const Text(
              'ĐĂNG XUẤT',
            ),
          ),
        ]),
      ),
    );
  }
}
