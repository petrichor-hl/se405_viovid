import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/features/auth/bloc/auth_bloc.dart';
import 'package:viovid_app/features/user-profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/features/user-profile/dtos/user_profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _redirect() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.read<AuthBloc>().add(AuthCheckLocalStorage());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Executes a function only one time after the layout is completed
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (ctx, state) {
            switch (state) {
              case AuthLoginSuccess():
                ctx.read<UserProfileCubit>().getUserProfile();
                break;
              case AuthUnauthenticated():
                context.go(RouteName.onboarding);
                break;
              default:
            }
          },
        ),
        BlocListener<UserProfileCubit, UserProfile?>(
          listener: (ctx, state) {
            if (state != null) {
              ctx.go(RouteName.bottomNav);
            }
          },
        )
      ],
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
