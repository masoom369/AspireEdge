class Testimonial {
  final String id;
  final String userId;
  final String content;

  Testimonial({required this.id, required this.userId, required this.content});

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
    };
  }

  @override
  String toString() => 'Testimonial(id: $id, userId: $userId, content: $content)';
}
