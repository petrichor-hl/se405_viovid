import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/data/profile_data.dart';
import 'package:viovid_app/data/topics_data.dart';
import 'package:viovid_app/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _redirect() async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      await fetchTopicsData();
      await fetchProfileData();
      if (mounted) {
        context.go('/bottom_nav');
      }
    } else {
      context.go('/onboarding');
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
