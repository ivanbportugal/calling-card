import 'package:calling_card/friends/friends_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late FriendsRepository repository;

  setUp(() {
    dio = MockDio();
    repository = FriendsRepository(dio: dio);
  });

  test('getFriends parses the friend list', () async {
    when(() => dio.get<dynamic>(any())).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/friends'),
        statusCode: 200,
        data: [
          {'id': 'f1', 'displayName': 'Jessica', 'email': 'j@example.com', 'photoUrl': '', 'status': 'GREEN'},
        ],
      ),
    );

    final friends = await repository.getFriends();

    expect(friends, hasLength(1));
    expect(friends.first.displayName, 'Jessica');
    verify(() => dio.get<dynamic>('/friends')).called(1);
  });

  test('getFriendRequests parses incoming and outgoing requests', () async {
    when(() => dio.get<dynamic>(any())).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/friends/requests'),
        statusCode: 200,
        data: {
          'incoming': [
            {
              'id': 'r1',
              'createdAt': '2026-01-01T00:00:00.000Z',
              'user': {'id': 'u1', 'displayName': 'Jo'},
            },
          ],
          'outgoing': <dynamic>[],
        },
      ),
    );

    final requests = await repository.getFriendRequests();

    expect(requests.incoming, hasLength(1));
    expect(requests.incoming.first.user.displayName, 'Jo');
    expect(requests.outgoing, isEmpty);
  });

  test('searchByEmail returns a matching friend', () async {
    when(() => dio.get<dynamic>(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/friends/search'),
        statusCode: 200,
        data: {'id': 'u2', 'displayName': 'Jessica', 'email': 'jessica@example.com', 'photoUrl': ''},
      ),
    );

    final friend = await repository.searchByEmail('jessica@example.com');

    expect(friend?.id, 'u2');
    verify(() => dio.get<dynamic>(
          '/friends/search',
          queryParameters: {'email': 'jessica@example.com'},
        )).called(1);
  });

  test('searchByEmail returns null when no user matches', () async {
    when(() => dio.get<dynamic>(any(), queryParameters: any(named: 'queryParameters')))
        .thenThrow(DioException(
      requestOptions: RequestOptions(path: '/friends/search'),
      response: Response(requestOptions: RequestOptions(path: '/friends/search'), statusCode: 404),
    ));

    final friend = await repository.searchByEmail('nobody@example.com');

    expect(friend, isNull);
  });

  test('sendFriendRequest posts the addresseeId', () async {
    when(() => dio.post<dynamic>(any(), data: any(named: 'data')))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: '/friends/requests'), statusCode: 201));

    await repository.sendFriendRequest('u2');

    verify(() => dio.post<dynamic>('/friends/requests', data: {'addresseeId': 'u2'})).called(1);
  });

  test('acceptFriendRequest posts to the accept endpoint', () async {
    when(() => dio.post<dynamic>(any()))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 200));

    await repository.acceptFriendRequest('r1');

    verify(() => dio.post<dynamic>('/friends/requests/r1/accept')).called(1);
  });

  test('declineFriendRequest deletes the request', () async {
    when(() => dio.delete<dynamic>(any()))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 204));

    await repository.declineFriendRequest('r1');

    verify(() => dio.delete<dynamic>('/friends/requests/r1')).called(1);
  });

  test('removeFriend deletes the friendship', () async {
    when(() => dio.delete<dynamic>(any()))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 204));

    await repository.removeFriend('f1');

    verify(() => dio.delete<dynamic>('/friends/f1')).called(1);
  });
}
