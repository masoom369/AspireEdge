class NotificationTarget {
  final int notificationId;
  final int userId;
  final int? readAt;

  NotificationTarget({
    required this.notificationId,
    required this.userId,
    this.readAt,
  });

  NotificationTarget.fromJson(Map<dynamic, dynamic> json)
      : notificationId = json["notification_id"] as int,
        userId = json["user_id"] as int,
        readAt = json["read_at"] as int?;

  Map<String, dynamic> toJson() => {
        'notification_id': notificationId,
        'user_id': userId,
        'read_at': readAt,
      };

  Map<String, dynamic> toMap() => {
        'notification_id': notificationId,
        'user_id': userId,
        'read_at': readAt,
      };
}
