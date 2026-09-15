import 'package:calling_card/config/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth auth;
  late MockUser user;
  late AuthInterceptor interceptor;

  setUp(() {
    auth = MockFirebaseAuth();
    user = MockUser();
    interceptor = AuthInterceptor(auth);
  });

  Future<RequestOptions> runOnRequest(RequestOptions options) async {
    await interceptor.onRequest(options, RequestInterceptorHandler());
    return options;
  }

  test('attaches a bearer auth header when a user is signed in', () async {
    when(() => auth.currentUser).thenReturn(user);
    when(() => user.getIdToken()).thenAnswer((_) async => 'id-token-123');

    final options = await runOnRequest(RequestOptions(path: '/profile'));

    expect(options.headers['Authorization'], 'Bearer id-token-123');
  });

  test('omits the auth header when there is no signed-in user', () async {
    when(() => auth.currentUser).thenReturn(null);

    final options = await runOnRequest(RequestOptions(path: '/profile'));

    expect(options.headers.containsKey('Authorization'), isFalse);
  });
}
