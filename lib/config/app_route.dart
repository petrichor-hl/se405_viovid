import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_api_service.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/screens/auth/auth.dart';
import 'package:viovid_app/screens/film_detail/film_detail.screen.dart';
import 'package:viovid_app/screens/main/bottom_nav.dart';
import 'package:viovid_app/screens/onboarding/onboarding.dart';
import 'package:viovid_app/screens/splash.dart';

class RouteName {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String bottomNav = '/bottom-nav';
  static const String filmDetail = '/film-detail/:id';
}

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouteName.splash,
      builder: (ctx, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteName.onboarding,
      builder: (ctx, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteName.auth,
      builder: (ctx, state) => const AuthScreen(),
    ),
    GoRoute(
      path: RouteName.bottomNav,
      builder: (ctx, state) => const BottomNavScreen(),
    ),
    GoRoute(
      path: RouteName.filmDetail,
      builder: (ctx, state) {
        final filmId = state.pathParameters['id']!;
        return RepositoryProvider(
          create: (ctx) => FilmDetailRepository(
            filmDetailApiService: FilmDetailApiService(dio),
          ),
          child: BlocProvider(
            create: (ctx) => FilmDetailCubit(
              ctx.read<FilmDetailRepository>(),
            ),
            child: FilmDetailScreen(
              filmId: filmId,
            ),
          ),
        );
      },
    ),
  ],
);
