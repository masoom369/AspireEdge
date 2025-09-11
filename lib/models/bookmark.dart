class Bookmark {
  final String id;
  final String userId;
  final String resourceId;

  Bookmark({required this.id, required this.userId, required this.resourceId});

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String,
      userId: json['userId'] as String,
      resourceId: json['resourceId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'resourceId': resourceId,
    };
  }

  @override
  String toString() => 'Bookmark(id: $id, userId: $userId, resourceId: $resourceId)';
}
