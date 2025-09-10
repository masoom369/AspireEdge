class Notification {
  final int id;
  final String title;
  final String body;
  final dynamic data;
  final int sentAt;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.data,
    required this.sentAt,
  });

  Notification.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        title = json["title"] as String,
        body = json["body"] as String,
        data = json["data"],
        sentAt = json["sent_at"] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'data': data,
        'sent_at': sentAt,
      };
}