import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/dio_client.dart';
import '../models/friend.dart';
import '../models/friend_request.dart';

final friendsRepositoryProvider = Provider<FriendsRepository>((ref) {
  return FriendsRepository(dio: ref.watch(dioProvider));
});

final friendsProvider = FutureProvider<List<Friend>>((ref) {
  return ref.watch(friendsRepositoryProvider).getFriends();
});

final friendRequestsProvider = FutureProvider<FriendRequests>((ref) {
  return ref.watch(friendsRepositoryProvider).getFriendRequests();
});

class FriendsRepository {
  FriendsRepository({Dio? dio}) : _dio = dio ?? createDio();

  final Dio _dio;

  Future<List<Friend>> getFriends() async {
    final response = await _dio.get('/friends');
    return (response.data as List<dynamic>)
        .map((e) => Friend.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FriendRequests> getFriendRequests() async {
    final response = await _dio.get('/friends/requests');
    return FriendRequests.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Friend?> searchByEmail(String email) async {
    try {
      final response = await _dio.get(
        '/friends/search',
        queryParameters: {'email': email},
      );
      return Friend.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<void> sendFriendRequest(String addresseeId) async {
    await _dio.post('/friends/requests', data: {'addresseeId': addresseeId});
  }

  Future<void> acceptFriendRequest(String requestId) async {
    await _dio.post('/friends/requests/$requestId/accept');
  }

  Future<void> declineFriendRequest(String requestId) async {
    await _dio.delete('/friends/requests/$requestId');
  }

  Future<void> removeFriend(String friendId) async {
    await _dio.delete('/friends/$friendId');
  }
}
