class User {
  final int id;
  final String role;
  final int tierId;
  final String name;
  final String email;
  final String passwordHash;
  final String? phone;
  final String? avatarUrl;
  final int createdAt;

  User({
    required this.id,
    required this.role,
    required this.tierId,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.phone,
    this.avatarUrl,
    required this.createdAt,
  });

  User.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        role = json["role"] as String,
        tierId = json["tier_id"] as int,
        name = json["name"] as String,
        email = json["email"] as String,
        passwordHash = json["password_hash"] as String,
        phone = json["phone"] as String?,
        avatarUrl = json["avatar_url"] as String?,
        createdAt = json["created_at"] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'tier_id': tierId,
        'name': name,
        'email': email,
        'password_hash': passwordHash,
        'phone': phone,
        'avatar_url': avatarUrl,
        'created_at': createdAt,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'role': role,
        'tier_id': tierId,
        'name': name,
        'email': email,
        'password_hash': passwordHash,
        'phone': phone,
        'avatar_url': avatarUrl,
        'created_at': createdAt,
      };
}
