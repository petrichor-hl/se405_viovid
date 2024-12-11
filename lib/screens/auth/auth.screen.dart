import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/features/auth/bloc/auth_bloc.dart';
import 'package:viovid_app/screens/auth/sign_in.dart';
import 'package:viovid_app/screens/auth/sign_up.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (_pageController.page == 1.0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        } else {
          context.pop();
          context.read<AuthBloc>().add(
                AuthStarted(),
              );
        }
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
