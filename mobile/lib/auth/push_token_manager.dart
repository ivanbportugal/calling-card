import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../config/dio_client.dart';

class PushTokenManager {
  PushTokenManager({FirebaseMessaging? messaging, Dio? dio})
      : _messaging = messaging ?? FirebaseMessaging.instance,
        _dio = dio ?? createDio();

  final FirebaseMessaging _messaging;
  final Dio _dio;

  Future<void> initialize() async {
    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    await Future.delayed(Duration(seconds: 1));

    final token = await _messaging.getToken();
    if (token != null) {
      await sendTokenToServer(token);
    }

    _messaging.onTokenRefresh.listen(sendTokenToServer);
  }

  Future<void> sendTokenToServer(String fcmToken) async {
    await _dio.post('/profile', data: {'fcmToken': fcmToken});
  }
}
