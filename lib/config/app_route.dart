import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_api_service.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/films_by_genre/cubit/films_by_genre_cubit.dart';
import 'package:viovid_app/features/films_by_genre/data/films_by_genre_api_service.dart';
import 'package:viovid_app/features/films_by_genre/data/films_by_genre_repository.dart';
import 'package:viovid_app/features/person_detail/cubit/person_detail_cubit.dart';
import 'package:viovid_app/features/person_detail/data/person_detail_api_service.dart';
import 'package:viovid_app/features/person_detail/data/person_detail_repository.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_api_service.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_repository.dart';
import 'package:viovid_app/screens/auth/auth.screen.dart';
import 'package:viovid_app/screens/change_password/change_password.screen.dart';
import 'package:viovid_app/screens/film_detail/film_detail.screen.dart';
import 'package:viovid_app/screens/films_by_genre/films_by_genre.screen.dart';
import 'package:viovid_app/screens/main/bottom_nav.dart';
import 'package:viovid_app/screens/my_list/my_list.screen.dart';
import 'package:viovid_app/screens/onboarding/onboarding.screen.dart';
import 'package:viovid_app/screens/person_detail/person_detail.screen.dart';
import 'package:viovid_app/screens/spash/splash.screen.dart';

class RouteName {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String bottomNav = '/bottom-nav';
  static const String filmDetail = '/film-detail/:id';
  static const String myList = '/my-list';
  static const String person = '/person/:id';
  static const String genre = '/genre/:id';
  static const String changePassword = '/change-password';
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
    GoRoute(
      path: RouteName.myList,
      builder: (ctx, state) => const MyListScreen(),
    ),
    GoRoute(
      path: RouteName.person,
      builder: (ctx, state) {
        final personId = state.pathParameters['id']!;
        return BlocProvider(
          create: (ctx) => PersonDetailCubit(
            PersonDetailRepository(
              personDetailApiService: PersonDetailApiService(dio),
            ),
          ),
          child: PersonDetailScreen(personId: personId),
        );
      },
    ),
    GoRoute(
      path: RouteName.genre,
      builder: (ctx, state) {
        final genreId = state.pathParameters['id']!;
        final extra = state.extra
            as Map<String, dynamic>; // Cast extra to Map<String, dynamic>
        final genreName = extra['genre_name'] as String; // Handle null safety

        return BlocProvider(
          create: (context) => FilmsByGenreCubit(
            FilmsByGenreRepository(
              filmsByGenreApiService: FilmsByGenreApiService(dio),
            ),
          ),
          child: FilmsByGenreScreen(
            genreId: genreId,
            genreName: genreName,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteName.changePassword,
      builder: (ctx, state) {
        return BlocProvider(
          create: (context) => UserProfileCubit(
            UserProfileRepository(
              userProfileApiService: UserProfileApiService(dio),
            ),
          ),
          child: const ChangePasswordScreen(),
        );
      },
    ),
  ],
);
