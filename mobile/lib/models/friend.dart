import '../auth/user.dart';

/// Mock friend list for the UI — there is no friends API yet.
class Friend {
  final String name;
  final StatusColor status;

  const Friend({required this.name, required this.status});
}

const mockFriends = [
  Friend(name: 'Sarah', status: StatusColor.GREEN),
  Friend(name: 'Mike', status: StatusColor.YELLOW),
  Friend(name: 'Jessica', status: StatusColor.RED),
  Friend(name: 'Alex', status: StatusColor.GREEN),
];
