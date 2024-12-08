import 'package:go_router/go_router.dart';
import 'package:viovid_app/screens/auth/auth.dart';
import 'package:viovid_app/screens/main/bottom_nav.dart';
import 'package:viovid_app/screens/onboarding/onboarding.dart';
import 'package:viovid_app/screens/splash.dart';

class RouteName {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String bottomNav = '/bottom-nav';
}

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouteName.splash,
      name: 'splash',
      builder: (ctx, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteName.onboarding,
      name: 'onboarding',
      builder: (ctx, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteName.auth,
      name: 'auth',
      builder: (ctx, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/bottom-nav',
      name: 'bottom-nav',
      builder: (ctx, state) => const BottomNavScreen(),
    ),
  ],
);
