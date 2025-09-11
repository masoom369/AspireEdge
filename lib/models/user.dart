class User {
  final String uuid;
  final String role;
  final String tier;
  final String username;

  User({
    required this.uuid,
    required this.role,
    required this.tier,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'] as String,
      role: json['role'] as String,
      tier: json['tier'] as String,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'role': role,
      'tier': tier,
      'username': username,
    };
  }

  @override
  String toString() =>
      'User(uuid: $uuid, role: $role, tier: $tier, username: $username)';
}
