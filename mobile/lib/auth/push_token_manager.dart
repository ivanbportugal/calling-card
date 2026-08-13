import 'package:firebase_messaging/firebase_messaging.dart';

// 1. Request notification permission (required on iOS)
NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();

if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// 2. Get the initial token
String? token = await FirebaseMessaging.instance.getToken();
if (token != null) {
// await sendTokenToServer(token); // Send to your Node.js API
}

// 3. Listen for token rotations (important!)
FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
// sendTokenToServer(newToken);
});
}