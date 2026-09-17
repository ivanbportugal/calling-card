import 'dart:io';

class ApiConfig {
  static final String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: Platform.isIOS
        ? 'http://localhost:3000/api'
        : 'http://10.0.2.2:3000/api',
    // defaultValue: 'https://calling-card.vercel.app/api',
  );
}
