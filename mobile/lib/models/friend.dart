import '../auth/user.dart';

class Friend {
  final String id;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final StatusColor? status;

  const Friend({
    required this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.status,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as String,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      status: json['status'] != null ? StatusColor.values.byName(json['status'] as String) : null,
    );
  }
}
