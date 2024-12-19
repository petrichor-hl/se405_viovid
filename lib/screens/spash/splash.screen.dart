import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/features/auth/bloc/auth_bloc.dart';
import 'package:viovid_app/features/my_list/cubit/my_list_cubit.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/helpers/notification_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckLocalStorage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) async {
        switch (state) {
          case AuthLoginSuccess():
            await ctx.read<UserProfileCubit>().getUserProfile();
            await ctx.read<UserProfileCubit>().getTrackingProgress();
            await ctx.read<MyListCubit>().getMyList();

            final notiHelper = NotificationHelper();
            await notiHelper.initLocalNotification();

            final payloadFcmNoti = await notiHelper.getPayloadFromFcmNoti();
            final payloadLocalNoti = await notiHelper.getPayloadFromLocalNoti();

            if (payloadFcmNoti != null) {
              NotificationHelper.handleNavigateNotification(
                payloadFcmNoti,
                isResetRoute: true,
              );
              break;
            }

            if (payloadLocalNoti != null) {
              NotificationHelper.handleNavigateNotification(
                payloadLocalNoti,
                isResetRoute: true,
              );
              break;
            }

            appRouter.go(RouteName.bottomNav);
            break;
          case AuthUnauthenticated():
            ctx.go(RouteName.onboarding);
            break;
          default:
        }
      },
      child: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Shimmer.fromColors(
          baseColor: primaryColor,
          highlightColor: Colors.amber,
          child: Image.asset(
            Assets.viovidLogo,
            width: 240,
          ),
        ),
      ),
    );
  }
}
