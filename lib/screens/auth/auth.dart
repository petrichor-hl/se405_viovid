import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/data/profile_data.dart';
import 'package:viovid_app/data/topics_data.dart';
import 'package:viovid_app/main.dart';
import 'package:viovid_app/screens/auth/sign_in.dart';
import 'package:viovid_app/screens/auth/sign_up.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _pageController = PageController(initialPage: 0);

  late final StreamSubscription<AuthState> _authSubscription;

  void _redirect() async {
    await fetchTopicsData();
    // await getDownloadedFilms();
    await fetchProfileData();
    if (mounted) {
      context.go('/bottom_nav');
    }
  }

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        _redirect();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageController.page == 1.0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Hero(
            tag: 'NetflixLogo',
            child: Image.asset(
              Assets.viovidLogo,
              width: 140,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text(
                'Trợ giúp',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: PageView(
          controller: _pageController,
          children: [
            SignInScreen(pageController: _pageController),
            const SignUpScreen(),
          ],
        ),
      ),
    );
  }
}
