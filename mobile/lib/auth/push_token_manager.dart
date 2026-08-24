import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../config/api_config.dart';

class PushTokenManager {
  PushTokenManager({FirebaseMessaging? messaging, FirebaseAuth? auth, Dio? dio})
      : _messaging = messaging ?? FirebaseMessaging.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final FirebaseMessaging _messaging;
  final FirebaseAuth _auth;
  final Dio _dio;

  Future<void> initialize() async {
    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    final token = await _messaging.getToken();
    if (token != null) {
      await sendTokenToServer(token);
    }

    _messaging.onTokenRefresh.listen(sendTokenToServer);
  }

  Future<void> sendTokenToServer(String fcmToken) async {
    final idToken = await _auth.currentUser?.getIdToken();
    await _dio.post(
      '/profile',
      data: {'fcmToken': fcmToken},
      options: Options(
        headers: {
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
      ),
    );
  }
}
