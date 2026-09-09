import 'package:calling_card/auth/push_token_manager.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockDio extends Mock implements Dio {}

const _authorizedSettings = NotificationSettings(
  alert: AppleNotificationSetting.enabled,
  announcement: AppleNotificationSetting.notSupported,
  authorizationStatus: AuthorizationStatus.authorized,
  badge: AppleNotificationSetting.enabled,
  carPlay: AppleNotificationSetting.notSupported,
  lockScreen: AppleNotificationSetting.enabled,
  notificationCenter: AppleNotificationSetting.enabled,
  showPreviews: AppleShowPreviewSetting.always,
  timeSensitive: AppleNotificationSetting.notSupported,
  criticalAlert: AppleNotificationSetting.notSupported,
  sound: AppleNotificationSetting.enabled,
  providesAppNotificationSettings: AppleNotificationSetting.notSupported,
);

const _deniedSettings = NotificationSettings(
  alert: AppleNotificationSetting.disabled,
  announcement: AppleNotificationSetting.notSupported,
  authorizationStatus: AuthorizationStatus.denied,
  badge: AppleNotificationSetting.disabled,
  carPlay: AppleNotificationSetting.notSupported,
  lockScreen: AppleNotificationSetting.disabled,
  notificationCenter: AppleNotificationSetting.disabled,
  showPreviews: AppleShowPreviewSetting.never,
  timeSensitive: AppleNotificationSetting.notSupported,
  criticalAlert: AppleNotificationSetting.notSupported,
  sound: AppleNotificationSetting.disabled,
  providesAppNotificationSettings: AppleNotificationSetting.notSupported,
);

void main() {
  late MockFirebaseMessaging messaging;
  late MockFirebaseAuth auth;
  late MockUser user;
  late MockDio dio;
  late PushTokenManager manager;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    messaging = MockFirebaseMessaging();
    auth = MockFirebaseAuth();
    user = MockUser();
    dio = MockDio();
    manager = PushTokenManager(messaging: messaging, auth: auth, dio: dio);

    when(() => auth.currentUser).thenReturn(user);
    when(() => user.getIdToken()).thenAnswer((_) async => 'id-token-123');
    when(() => dio.post<dynamic>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/profile'),
        statusCode: 200,
      ),
    );
  });

  test('sends the fcm token to /profile with a bearer auth header', () async {
    when(() => messaging.requestPermission()).thenAnswer((_) async => _authorizedSettings);
    when(() => messaging.getToken()).thenAnswer((_) async => 'fcm-token-abc');
    when(() => messaging.onTokenRefresh).thenAnswer((_) => const Stream<String>.empty());

    await manager.initialize();

    final captured = verify(() => dio.post<dynamic>(
          '/profile',
          data: captureAny(named: 'data'),
          options: captureAny(named: 'options'),
        )).captured;

    expect(captured[0], {'fcmToken': 'fcm-token-abc'});
    final options = captured[1] as Options;
    expect(options.headers?['Authorization'], 'Bearer id-token-123');
  });

  test('does not send a token when permission is denied', () async {
    when(() => messaging.requestPermission()).thenAnswer((_) async => _deniedSettings);
    when(() => messaging.onTokenRefresh).thenAnswer((_) => const Stream<String>.empty());

    await manager.initialize();

    verifyNever(() => messaging.getToken());
    verifyNever(() => dio.post<dynamic>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ));
  });

  test('does not send when no token is available', () async {
    when(() => messaging.requestPermission()).thenAnswer((_) async => _authorizedSettings);
    when(() => messaging.getToken()).thenAnswer((_) async => null);
    when(() => messaging.onTokenRefresh).thenAnswer((_) => const Stream<String>.empty());

    await manager.initialize();

    verifyNever(() => dio.post<dynamic>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ));
  });

  test('sends refreshed token when onTokenRefresh fires', () async {
    when(() => messaging.requestPermission()).thenAnswer((_) async => _authorizedSettings);
    when(() => messaging.getToken()).thenAnswer((_) async => 'fcm-token-initial');
    when(() => messaging.onTokenRefresh).thenAnswer((_) => Stream.value('fcm-token-refreshed'));

    await manager.initialize();
    await Future<void>.delayed(Duration.zero);

    verify(() => dio.post<dynamic>(
          '/profile',
          data: {'fcmToken': 'fcm-token-refreshed'},
          options: any(named: 'options'),
        )).called(1);
  });

  test('omits the Authorization header when there is no signed-in user', () async {
    when(() => auth.currentUser).thenReturn(null);

    await manager.sendTokenToServer('fcm-token-xyz');

    final captured = verify(() => dio.post<dynamic>(
          '/profile',
          data: captureAny(named: 'data'),
          options: captureAny(named: 'options'),
        )).captured;

    expect(captured[0], {'fcmToken': 'fcm-token-xyz'});
    final options = captured[1] as Options;
    expect(options.headers?.containsKey('Authorization'), isFalse);
  });
}
