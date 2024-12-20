import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_repository.dart';

class NotificationHelper {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications(BuildContext context) async {
    //
    await requestNotificationPermission();

    final fcmToken = await _firebaseMessaging.getToken();
    log('FCM Token = $fcmToken');

    final userProfile = context.read<UserProfileCubit>().state.userProfile;
    log('userProfile.fcmToken = ${userProfile?.fcmToken}');

    if (fcmToken != null &&
        userProfile != null &&
        fcmToken != userProfile.fcmToken) {
      await context.read<UserProfileRepository>().updateFcmToken(fcmToken);
    }

    _firebaseMessaging.onTokenRefresh.listen((newFcmToken) {
      log('NEW_FCM_TOKEN = $newFcmToken');
    });

    await FirebaseMessaging.instance.subscribeToTopic("NewFilm");
    await FirebaseMessaging.instance.subscribeToTopic("NewCommentOnYourPost");
  }

  Future<void> initLocalNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // Xử lý khi người dùng click vào Noti khi đang ở trạng thái Foreground và Background
      onDidReceiveNotificationResponse: _onPressLocalNotification,
      // onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<Map<String, dynamic>?> getPayloadFromFcmNoti() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      return initialMessage.data;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getPayloadFromLocalNoti() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final payload =
          notificationAppLaunchDetails?.notificationResponse?.payload;

      final Map<String, dynamic> data = jsonDecode(payload!);
      return data;
    }
    return null;
  }

  void _onPressLocalNotification(NotificationResponse response) {
    print('_onPressLocalNotification');
    if (response.payload != null) {
      final Map<String, dynamic> data = jsonDecode(response.payload!);
      handleNavigateNotification(data);
    }
  }

  Future<void> removeNotificationListener() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic("NewFilm");
    await FirebaseMessaging.instance
        .unsubscribeFromTopic("NewCommentOnYourPost");
  }

  Future<void> requestNotificationPermission() async {
    final settings = await _firebaseMessaging.requestPermission();

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        log('User granted permission');
        break;
      case AuthorizationStatus.denied:
        log('Notification permission denied');
        break;
      case AuthorizationStatus.provisional:
        log('User granted provisional permission');
        break;
      case AuthorizationStatus.notDetermined:
        log('Notification permission was not determined');
        break;
    }
  }

  Future<void> pushLocalInstantNotification({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(data),
    );
  }

  static void handleNavigateNotification(
    Map<String, dynamic> data, {
    bool isResetRoute = false,
  }) {
    if (data['type'] == 'NewFilm') {
      isResetRoute
          ? appRouter.go(
              RouteName.filmDetail.replaceFirst(
                ':id',
                data['filmId'],
              ),
            )
          : appRouter.push(
              RouteName.filmDetail.replaceFirst(
                ':id',
                data['filmId'],
              ),
            );
    }

    if (data['type'] == 'NewCommentOnYourPost') {}
  }
}
