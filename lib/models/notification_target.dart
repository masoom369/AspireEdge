class NotificationTarget {
  final String id;
  final String targetType;
  final String targetId;

  NotificationTarget({
    required this.id,
    required this.targetType,
    required this.targetId,
  });

  factory NotificationTarget.fromJson(Map<String, dynamic> json) {
    return NotificationTarget(
      id: json['id'] as String,
      targetType: json['targetType'] as String,
      targetId: json['targetId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetType': targetType,
      'targetId': targetId,
    };
  }

  @override
  String toString() =>
      'NotificationTarget(id: $id, targetType: $targetType, targetId: $targetId)';
}
