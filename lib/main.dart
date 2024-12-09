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
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_api_service.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sf = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Ctrl + F5
  // flutter run --dart-define-from-file=lib/config/.env
  runApp(MyApp(
    sharedPreferences: sf,
  ));
  //
}

// const openAIApiKey = String.fromEnvironment('OPEN_AI_API_KEY');
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => AuthBloc(
            AuthRepository(
              authApiService: AuthApiService(dio),
              authLocalStorageService:
                  AuthLocalStorageService(sharedPreferences),
            ),
          ),
        ),
        BlocProvider(
          create: (ctx) => UserProfileCubit(
            UserProfileRepository(
              userProfileApiService: UserProfileApiService(dio),
            ),
          ),
        ),
      ],
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
    );
  }
}
