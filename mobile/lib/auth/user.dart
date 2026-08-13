class User {
  final String id;
  final String firebaseUid;
  final String email;
  final String phoneNumber;
  final String displayName;
  final String photoUrl;
  final bool notificationsEnabled;
  final UserStatus? status;

  User({
    required this.id,
    required this.firebaseUid,
    required this.email,
    required this.phoneNumber,
    required this.displayName,
    required this.photoUrl,
    required this.notificationsEnabled,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firebaseUid: json['firebaseUid'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      status: json['status'] != null
          ? UserStatus.fromJson(json['status'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebaseUid': firebaseUid,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'notificationsEnabled': notificationsEnabled,
      'status': status?.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? firebaseUid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoUrl,
    bool? notificationsEnabled,
    UserStatus? status,
  }) {
    return User(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      status: status ?? this.status,
    );
  }
}

class UserStatus {
  final StatusColor color;

  UserStatus(this.color);

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      StatusColor.values.byName(json['color'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color.name,
    };
  }

  UserStatus copyWith({
    StatusColor? color,
  }) {
    return UserStatus(
      color ?? this.color,
    );
  }
}

enum StatusColor { GREEN, YELLOW, RED }