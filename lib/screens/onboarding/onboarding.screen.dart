import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/screens/onboarding/intro_page/intro_page_1.dart';
import 'package:viovid_app/screens/onboarding/intro_page/intro_page_2.dart';
import 'package:viovid_app/screens/onboarding/intro_page/intro_page_3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnboardingScreen> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Positioned(
            top: 0,
            left: 20,
            right: 8,
            child: SafeArea(
              child: Row(
                children: [
                  Hero(
                    tag: 'NetflixLogo',
                    child: Image.asset(
                      Assets.viovidLogo,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: const Text(
                      'Quyền riêng tư',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(10),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: const Text(
                      'Trợ giúp',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    axisDirection: Axis.horizontal,
                    effect: const WormEffect(
                      spacing: 10,
                      radius: 5,
                      dotWidth: 10,
                      dotHeight: 10,
                      paintStyle: PaintingStyle.fill,
                      dotColor: Colors.grey,
                      activeDotColor: primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 40,
                    child: FilledButton(
                      onPressed: () {
                        context.push('/auth');
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'BẮT ĐẦU',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (MediaQuery.of(context).padding.bottom == 0) const Gap(20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
