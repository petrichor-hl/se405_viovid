import 'dart:developer';

import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
import 'package:viovid_app/features/noti_center/cubit/noti_center_cubit.dart';
import 'package:viovid_app/features/noti_center/data/noti_center_api_service.dart';
import 'package:viovid_app/features/noti_center/data/noti_center_repository.dart';
import 'package:viovid_app/features/noti_center/dtos/user_notification.dart';
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

  OpenAI.apiKey = openAIApiKey;

  // Ctrl + F5
  // flutter run --dart-define-from-file=lib/config/.env
  runApp(
    BlocProvider(
      create: (ctx) => NotiCenterCubit(
        NotiCenterRepository(
          notiCenterApiService: NotiCenterApiService(dio),
        ),
      ),
      child: MyApp(
        sharedPreferences: sf,
      ),
    ),
  );
}

const openAIApiKey =
    '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';

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
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      _addNotiToCenter(message);
      _handleNotification(message);
    });

    // Xử lý NHẬN thông báo khi app đang chạy ở trạng thái Foreground
    FirebaseMessaging.onMessage.listen((message) async {
      await NotificationHelper().pushLocalInstantNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        data: message.data,
      );

      _addNotiToCenter(message);
    });
  }

  void _addNotiToCenter(RemoteMessage message) async {
    context.read<NotiCenterCubit>().addNotiToCenter(
          UserNotification(
            id: message.data['userNotificationId'],
            category: int.parse(message.data['category']),
            createdDateTime: DateFormat('dd/MM/yyyy HH:mm:ss').parse(
              message.data['createdDateTime'],
            ),
            // title: title,
            // body: body,
            params: {
              "filmId": message.data['filmId'],
              "name": message.data['name'],
              "overview": message.data['overview'],
              "backdropPath": message.data['backdropPath'],
              "contentRating": message.data['contentRating'],
            },
          ),
        );
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
    return RepositoryProvider(
      create: (context) => UserProfileRepository(
        userProfileApiService: UserProfileApiService(dio),
      ),
      child: MultiBlocProvider(
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
              ctx.read<UserProfileRepository>(),
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
      ),
    );
  }
}
