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

  User.fromJson(Map<dynamic, dynamic> json)
      : uuid = json["uuid"] as String,
        role = json["role"] as String,
        tier = json["tier"] as String,
        username = json["username"] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uuid': uuid,
        'role': role,
        'tier': tier,
        'username': username,
      };

  Map<String, dynamic> toMap() => <String, dynamic>{
        'uuid': uuid,
        'role': role,
        'tier': tier,
        'username': username,
      };
}
