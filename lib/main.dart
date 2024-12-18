import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/features/auth/bloc/auth_bloc.dart';
import 'package:viovid_app/features/auth/data/auth_api_service.dart';
import 'package:viovid_app/features/auth/data/auth_local_data_source_service.dart';
import 'package:viovid_app/features/auth/data/auth_repository.dart';
import 'package:viovid_app/features/my_list/cubit/my_list_cubit.dart';
import 'package:viovid_app/features/my_list/data/my_list_api_service.dart';
import 'package:viovid_app/features/my_list/data/my_list_repository.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_api_service.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_repository.dart';
import 'package:viovid_app/firebase_options.dart';
import 'package:viovid_app/helpers/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sf = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Ctrl + F5
  // flutter run --dart-define-from-file=lib/config/.env

  runApp(
    MyApp(
      sharedPreferences: sf,
    ),
  );
}
// const openAIApiKey = String.fromEnvironment('OPEN_AI_API_KEY');

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  const MyApp({
    super.key,
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Xử lý khi app đang chạy ở trạng thái Background
    // Và User nhấn vào Notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);

    // Xử lý khi app đang chạy ở trạng thái Foreground
    FirebaseMessaging.onMessage.listen((message) async {
      await NotificationHelper().pushLocalInstantNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        data: message.data,
      );
    });
  }

  void _handleNotification(RemoteMessage message) async {
    // final data = message.data; // Dữ liệu của notification
    log('RemoteMessage: ');
    print(message.notification?.title);
    print(message.notification?.body);
    print(message.data);

    NotificationHelper.handleNavigateNotification(message.data);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => AuthBloc(
            AuthRepository(
              authApiService: AuthApiService(dio),
              authLocalStorageService:
                  AuthLocalStorageService(widget.sharedPreferences),
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
        BlocProvider(
          create: (ctx) => MyListCubit(
            MyListRepository(
              myListApiService: MyListApiService(dio),
            ),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Movie App',
        theme: ThemeData(
          appBarTheme: appBarTheme,
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
