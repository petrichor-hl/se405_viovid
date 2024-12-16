import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await requestNotificationPermission();

    final fcmToken = await _firebaseMessaging.getToken();
    log('FCM Token = $fcmToken');
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
}
