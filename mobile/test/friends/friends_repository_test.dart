import 'package:calling_card/friends/friends_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockFirebaseAuth auth;
  late MockUser user;
  late MockDio dio;
  late FriendsRepository repository;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    auth = MockFirebaseAuth();
    user = MockUser();
    dio = MockDio();
    repository = FriendsRepository(auth: auth, dio: dio);

    when(() => auth.currentUser).thenReturn(user);
    when(() => user.getIdToken()).thenAnswer((_) async => 'id-token-123');
  });

  test('getFriends parses the friend list with a bearer auth header', () async {
    when(() => dio.get<dynamic>(any(), options: any(named: 'options'))).thenAnswer(
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

    final captured = verify(() => dio.get<dynamic>('/friends', options: captureAny(named: 'options'))).captured;
    final options = captured.single as Options;
    expect(options.headers?['Authorization'], 'Bearer id-token-123');
  });

  test('getFriendRequests parses incoming and outgoing requests', () async {
    when(() => dio.get<dynamic>(any(), options: any(named: 'options'))).thenAnswer(
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

  test('sendFriendRequest posts the addresseeId', () async {
    when(() => dio.post<dynamic>(any(), data: any(named: 'data'), options: any(named: 'options')))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: '/friends/requests'), statusCode: 201));

    await repository.sendFriendRequest('u2');

    verify(() => dio.post<dynamic>('/friends/requests', data: {'addresseeId': 'u2'}, options: any(named: 'options')))
        .called(1);
  });

  test('acceptFriendRequest posts to the accept endpoint', () async {
    when(() => dio.post<dynamic>(any(), options: any(named: 'options')))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 200));

    await repository.acceptFriendRequest('r1');

    verify(() => dio.post<dynamic>('/friends/requests/r1/accept', options: any(named: 'options'))).called(1);
  });

  test('declineFriendRequest deletes the request', () async {
    when(() => dio.delete<dynamic>(any(), options: any(named: 'options')))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 204));

    await repository.declineFriendRequest('r1');

    verify(() => dio.delete<dynamic>('/friends/requests/r1', options: any(named: 'options'))).called(1);
  });

  test('removeFriend deletes the friendship', () async {
    when(() => dio.delete<dynamic>(any(), options: any(named: 'options')))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 204));

    await repository.removeFriend('f1');

    verify(() => dio.delete<dynamic>('/friends/f1', options: any(named: 'options'))).called(1);
  });
}
