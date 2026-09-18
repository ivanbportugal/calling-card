const _prefix = 'callingcard:email:';

String encodeEmailQr(String email) => '$_prefix$email';

String? decodeEmailQr(String raw) {
  if (!raw.startsWith(_prefix)) return null;
  final email = raw.substring(_prefix.length).trim();
  return email.isEmpty ? null : email;
}
