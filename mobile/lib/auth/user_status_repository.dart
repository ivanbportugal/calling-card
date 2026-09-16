import 'package:calling_card/auth/user.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/dio_client.dart';

final userStatusRepositoryProvider = Provider<UserStatusRepository>((ref) {
  return UserStatusRepository(dio: ref.watch(dioProvider));
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
  UserStatusRepository({Dio? dio}) : _dio = dio ?? createDio();

  final Dio _dio;

  Future<UserStatus> getStatus() async {
    final response = await _dio.get('/status');
    return UserStatus.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserStatus> updateStatus(UserStatus status) async {
    final response = await _dio.post('/status', data: status.toJson());
    return UserStatus.fromJson(response.data as Map<String, dynamic>);
  }
}