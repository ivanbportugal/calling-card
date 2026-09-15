import 'package:calling_card/auth/user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/api_config.dart';

final userStatusRepositoryProvider = Provider<UserStatusRepository>((ref) {
  return UserStatusRepository(auth: FirebaseAuth.instance);
});

final userStatusProvider =
AsyncNotifierProvider<UserStatusNotifier, UserStatus>(UserStatusNotifier.new);

class UserStatusNotifier extends AsyncNotifier<UserStatus> {
  @override
  Future<UserStatus> build() {
    return ref.read(userStatusRepositoryProvider).getStatus();
  }

  Future<void> updateStatus(UserStatus status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(userStatusRepositoryProvider).updateStatus(status);
    });
  }
}

class UserStatusRepository {
  UserStatusRepository({FirebaseAuth? auth, Dio? dio})
      : _auth = auth ?? FirebaseAuth.instance,
        _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final FirebaseAuth _auth;
  final Dio _dio;

  Future<UserStatus> getStatus() async {
    final idToken = await _auth.currentUser?.getIdToken();
    final response = await _dio.get(
      '/status',
      options: Options(
        headers: {
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
      ),
    );
    return UserStatus.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserStatus> updateStatus(UserStatus status) async {
    final idToken = await _auth.currentUser?.getIdToken();
    final response = await _dio.post(
      '/status',
      data: status.toJson(),
      options: Options(
        headers: {
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
      ),
    );
    return UserStatus.fromJson(response.data as Map<String, dynamic>);
  }
}