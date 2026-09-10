import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/api_config.dart';
import '../models/friend.dart';
import '../models/friend_request.dart';

final friendsRepositoryProvider = Provider<FriendsRepository>((ref) {
  return FriendsRepository(auth: FirebaseAuth.instance);
});

final friendsProvider = FutureProvider<List<Friend>>((ref) {
  return ref.watch(friendsRepositoryProvider).getFriends();
});

final friendRequestsProvider = FutureProvider<FriendRequests>((ref) {
  return ref.watch(friendsRepositoryProvider).getFriendRequests();
});

class FriendsRepository {
  FriendsRepository({FirebaseAuth? auth, Dio? dio})
      : _auth = auth ?? FirebaseAuth.instance,
        _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final FirebaseAuth _auth;
  final Dio _dio;

  Future<Options> _authOptions() async {
    final idToken = await _auth.currentUser?.getIdToken();
    return Options(
      headers: {
        if (idToken != null) 'Authorization': 'Bearer $idToken',
      },
    );
  }

  Future<List<Friend>> getFriends() async {
    final response = await _dio.get('/friends', options: await _authOptions());
    return (response.data as List<dynamic>)
        .map((e) => Friend.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FriendRequests> getFriendRequests() async {
    final response = await _dio.get('/friends/requests', options: await _authOptions());
    return FriendRequests.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> sendFriendRequest(String addresseeId) async {
    await _dio.post(
      '/friends/requests',
      data: {'addresseeId': addresseeId},
      options: await _authOptions(),
    );
  }

  Future<void> acceptFriendRequest(String requestId) async {
    await _dio.post('/friends/requests/$requestId/accept', options: await _authOptions());
  }

  Future<void> declineFriendRequest(String requestId) async {
    await _dio.delete('/friends/requests/$requestId', options: await _authOptions());
  }

  Future<void> removeFriend(String friendId) async {
    await _dio.delete('/friends/$friendId', options: await _authOptions());
  }
}
