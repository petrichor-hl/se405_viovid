import 'package:go_router/go_router.dart';
import 'package:viovid_app/screens/auth/auth.dart';
import 'package:viovid_app/screens/main/bottom_nav.dart';
import 'package:viovid_app/screens/onboarding/onboarding.dart';
import 'package:viovid_app/screens/splash.dart';

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (ctx, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (ctx, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (ctx, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/bottom_nav',
      name: 'bottom_nav',
      builder: (ctx, state) => const BottomNavScreen(),
    ),
    // GoRoute(
    //   path: '/confirmed-sign-up',
    //   name: 'confirmed-sign-up',
    // Ex: http://localhost:5416/#/confirmed-sign-up#access_token=eyJhbGciOiJIUzI1NiIsImtpZCI6IlV5T3p1UTE3UVNNRjgzbXEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2twYXhqam1lbGJxcGxseGVucHh6LnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiJmOGYxZDBiYy0wYTU2LTRkZDItYTg2YS1lYTAxMTYwZWU5ZTUiLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzI2MjI2NzM3LCJpYXQiOjE3MjYyMjMxMzcsImVtYWlsIjoiaGxnYW1lMTc0QGdtYWlsLmNvbSIsInBob25lIjoiIiwiYXBwX21ldGFkYXRhIjp7InByb3ZpZGVyIjoiZW1haWwiLCJwcm92aWRlcnMiOlsiZW1haWwiXX0sInVzZXJfbWV0YWRhdGEiOnsiYXZhdGFyX3VybCI6ImRlZmF1bHRfYXZ0LnBuZyIsImRvYiI6IjAxLzA1LzIwMDMiLCJlbWFpbCI6ImhsZ2FtZTE3NEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZ1bGxfbmFtZSI6IlRhbmcgVGhpIEtpbSBOZ3V5ZW4iLCJwYXNzd29yZCI6IjEyMzQ1NiIsInBob25lX3ZlcmlmaWVkIjpmYWxzZSwic3ViIjoiZjhmMWQwYmMtMGE1Ni00ZGQyLWE4NmEtZWEwMTE2MGVlOWU1In0sInJvbGUiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoib3RwIiwidGltZXN0YW1wIjoxNzI2MjIzMTM3fV0sInNlc3Npb25faWQiOiI2MWU1YmVhMS04MDNlLTQ5NDMtODU1Ni1hZGQwZjY4N2YzZTYiLCJpc19hbm9ueW1vdXMiOmZhbHNlfQ.Q_iao7y0KXVn56s2PB1drplNHrQHlwl1Cm4BBNVFlQc&expires_at=1726226737&expires_in=3600&refresh_token=7RVBNzh81-ZyEpNbYiUqCg&token_type=bearer&type=signup
    // builder: (ctx, state) {
    //   final params = Uri.splitQueryString(state.uri.fragment);
    //   return ConfirmedSignUp(
    //     refreshToken: params['refresh_token']!,
    //   );
    // },
    // ),
  ],
);
