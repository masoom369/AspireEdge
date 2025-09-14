class FeedbackModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String subject;
  final String inquiryType;
  final String message;
  final String status;
  final String reply;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.subject,
    required this.inquiryType,
    required this.message,
    this.status = "pending",
    this.reply = "",
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      subject: json['subject'] ?? '',
      inquiryType: json['inquiryType'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? 'pending',
      reply: json['reply'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'subject': subject,
      'inquiryType': inquiryType,
      'message': message,
      'status': status,
      'reply': reply,
    };
  }

  @override
  String toString() =>
      'Feedback(id: $id, userId: $userId, name: $name, email: $email, subject: $subject, inquiryType: $inquiryType, message: $message, status: $status, reply: $reply)';
}

