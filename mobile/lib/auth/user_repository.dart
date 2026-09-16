import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/dio_client.dart';
import 'user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(dio: ref.watch(dioProvider));
});

final userProfileProvider =
AsyncNotifierProvider<UserProfileNotifier, User>(UserProfileNotifier.new);

class UserProfileNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() {
    return ref.read(userRepositoryProvider).getProfile();
  }

  Future<void> updateProfile(User user) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(userRepositoryProvider).updateProfile(user);
    });
  }
}

class UserRepository {
  UserRepository({Dio? dio}) : _dio = dio ?? createDio();

  final Dio _dio;

  Future<User> getProfile() async {
    final response = await _dio.get('/profile');
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<User> updateProfile(User user) async {
    final response = await _dio.post('/profile', data: user.toJson());
    return User.fromJson(response.data as Map<String, dynamic>);
  }
}