class Notification {
  final String id;
  final String title;
  final String body;

  Notification({required this.id, required this.title, required this.body});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }

  @override
  String toString() => 'Notification(id: $id, title: $title, body: $body)';
}
