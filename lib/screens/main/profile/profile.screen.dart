import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/auth/bloc/auth_bloc.dart';

import 'package:viovid_app/screens/main/profile/components/profile_header.dart';
import 'package:viovid_app/screens/main/profile/components/profile_setting_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthUnauthenticated,
      listener: (context, state) {
        context.go(RouteName.onboarding);
      },
      buildWhen: (previous, current) =>
          current is AuthLogoutInProgress || current is AuthLogoutFailure,
      builder: (ctx, state) {
        var profileWidget = (switch (state) {
          AuthLoginSuccess() => _buildProfileWidget(context),
          AuthLogoutInProgress() => _buildInProgressProfileWidget(),
          // TODO: Khi logout failed => show popup
          AuthLogoutFailure() => _buildProfileWidget(context),
          _ => const SizedBox(),
        });

        return SafeArea(
          child: profileWidget,
        );
      },
    );
  }

  Widget _buildInProgressProfileWidget() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Gap(14),
          Text(
            'Đang đăng xuất',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileHeader(),
          ProfileSettingItem(
            title: 'Thông tin tài khoản',
            iconData: Icons.account_box,
            onTap: () {},
          ),
          ProfileSettingItem(
            title: 'Danh sách của tôi',
            iconData: Icons.list_rounded,
            onTap: () => context.push(RouteName.myList),
          ),
          ProfileSettingItem(
            title: 'Đổi mật khẩu',
            iconData: Icons.password_rounded,
            onTap: () => context.push(RouteName.changePassword),
          ),
          ProfileSettingItem(
            title: 'Lịch sử thanh toán',
            iconData: Icons.download_done_rounded,
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
                  surfaceTintColor: Theme.of(context).primaryColor,
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                        context.read<AuthBloc>().add(AuthLogout());
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
        ],
      ),
    );
  }
}
