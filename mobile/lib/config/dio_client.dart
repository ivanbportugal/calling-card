import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/auth_providers.dart';
import 'api_config.dart';

final dioProvider = Provider<Dio>((ref) {
  return createDio(auth: ref.watch(firebaseAuthProvider));
});

Dio createDio({FirebaseAuth? auth}) {
  return Dio(BaseOptions(baseUrl: ApiConfig.baseUrl))
    ..interceptors.add(AuthInterceptor(auth ?? FirebaseAuth.instance));
}

class AuthInterceptor extends QueuedInterceptorsWrapper {
  AuthInterceptor(this._auth);

  final FirebaseAuth _auth;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final idToken = await _auth.currentUser?.getIdToken();
    if (idToken != null) {
      options.headers['Authorization'] = 'Bearer $idToken';
    }
    handler.next(options);
  }
}
