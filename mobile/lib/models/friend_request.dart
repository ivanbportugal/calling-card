class FriendRequestUser {
  final String id;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  const FriendRequestUser({required this.id, this.displayName, this.email, this.photoUrl});

  factory FriendRequestUser.fromJson(Map<String, dynamic> json) {
    return FriendRequestUser(
      id: json['id'] as String,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }
}

class FriendRequest {
  final String id;
  final DateTime createdAt;
  final FriendRequestUser user;

  const FriendRequest({required this.id, required this.createdAt, required this.user});

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: FriendRequestUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class FriendRequests {
  final List<FriendRequest> incoming;
  final List<FriendRequest> outgoing;

  const FriendRequests({required this.incoming, required this.outgoing});

  factory FriendRequests.fromJson(Map<String, dynamic> json) {
    return FriendRequests(
      incoming: (json['incoming'] as List<dynamic>)
          .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      outgoing: (json['outgoing'] as List<dynamic>)
          .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
