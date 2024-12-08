import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/features/auth/data/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _redirect() async {
    if (mounted) {
      final authRepository = context.read<AuthRepository>();
      if (await authRepository.isAccessTokenExpired()) {
        final isRefreshed = await authRepository.refreshToken();
        if (isRefreshed) {
          if (mounted) {
            context.go('/bottom-nav');
          }
        } else {
          if (mounted) {
            context.go('/auth');
          }
        }
      } else {
        if (mounted) {
          context.go('/bottom-nav');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Executes a function only one time after the layout is completed
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
