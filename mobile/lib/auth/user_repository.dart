import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/api_config.dart';
import 'user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(auth: FirebaseAuth.instance);
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
  UserRepository({FirebaseAuth? auth, Dio? dio})
      : _auth = auth ?? FirebaseAuth.instance,
        _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final FirebaseAuth _auth;
  final Dio _dio;

  Future<User> getProfile() async {
    final idToken = await _auth.currentUser?.getIdToken();
    final response = await _dio.get(
      '/profile',
      options: Options(
        headers: {
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
      ),
    );
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<User> updateProfile(User user) async {
    final idToken = await _auth.currentUser?.getIdToken();
    final response = await _dio.post(
      '/profile',
      data: user.toJson(),
      options: Options(
        headers: {
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
      ),
    );
    return User.fromJson(response.data as Map<String, dynamic>);
  }
}