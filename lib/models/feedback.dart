class Feedback {
  final int id;
  final int userId;
  final String name;
  final String email;
  final String message;
  final int submittedAt;

  Feedback({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.message,
    required this.submittedAt,
  });

  Feedback.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        userId = json["user_id"] as int,
        name = json["name"] as String,
        email = json["email"] as String,
        message = json["message"] as String,
        submittedAt = json["submitted_at"] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'email': email,
        'message': message,
        'submitted_at': submittedAt,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'email': email,
        'message': message,
        'submitted_at': submittedAt,
      };
}
