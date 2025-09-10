class Bookmark {
  final int id;
  final int userId;
  final String objectType;
  final int objectId;
  final int createdAt;

  Bookmark({
    required this.id,
    required this.userId,
    required this.objectType,
    required this.objectId,
    required this.createdAt,
  });

  Bookmark.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        userId = json["user_id"] as int,
        objectType = json["object_type"] as String,
        objectId = json["object_id"] as int,
        createdAt = json["created_at"] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'object_type': objectType,
        'object_id': objectId,
        'created_at': createdAt,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'object_type': objectType,
        'object_id': objectId,
        'created_at': createdAt,
      };
}
