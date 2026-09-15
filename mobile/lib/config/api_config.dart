class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
    // defaultValue: 'https://calling-card.vercel.app/api',
  );
}
