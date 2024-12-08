import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/features/auth/bloc/auth_bloc.dart';
import 'package:viovid_app/features/auth/data/auth_api_service.dart';
import 'package:viovid_app/features/auth/data/auth_local_data_source_service.dart';
import 'package:viovid_app/features/auth/data/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sf = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // await Supabase.initialize(
  //   url: 'https://kpaxjjmelbqpllxenpxz.supabase.co',
  //   anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  //   authOptions: const FlutterAuthClientOptions(
  //     // authFlowType: AuthFlowType.pkce,
  //     authFlowType: AuthFlowType.implicit,
  //   ),
  //   /*
  //   If you use PKCE (default), this link only works on the device or browser where the original reset request was made. Display a message to the user to make sure they don't change devices or browsers.
  //   If you used PKCE (default), the redirect contains the code query param.
  //   If you use the implicit grant flow, the link can be opened on any device.
  //   If you used the implicit flow, the redirect contains a URL fragment encoding the user's session.

  //   More: https://supabase.com/docs/guides/auth/passwords
  //   */
  // );
  // flutter run --dart-define-from-file=lib/config/.env
  runApp(MyApp(
    sharedPreferences: sf,
  ));
  //
}

const openAIApiKey = String.fromEnvironment('OPEN_AI_API_KEY');
final supabase = Supabase.instance.client;
const tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');
const baseAvatarUrl =
    'https://kpaxjjmelbqpllxenpxz.supabase.co/storage/v1/object/public/avatar/';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (ctx) => AuthRepository(
        authApiService: AuthApiService(dio),
        authLocalStorageService: AuthLocalStorageService(sharedPreferences),
      ),
      child: BlocProvider(
        create: (ctx) => AuthBloc(ctx.read<AuthRepository>()),
        child: MaterialApp.router(
          routerConfig: appRouter,
          title: 'Movie App',
          theme: ThemeData(
            colorScheme: appColorScheme,
            filledButtonTheme: appFilledButtonTheme,
            textTheme: GoogleFonts.montserratTextTheme(),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.black,
            sliderTheme: const SliderThemeData(
              showValueIndicator: ShowValueIndicator.always,
            ),
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
