class Feedback {
  final String id;
  final String userId;
  final String message;

  Feedback({required this.id, required this.userId, required this.message});

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
    };
  }

  @override
  String toString() => 'Feedback(id: $id, userId: $userId, message: $message)';
}
