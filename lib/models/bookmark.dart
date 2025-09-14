class Bookmark {
  final String uuid;
  final String resourceId;

  Bookmark({
    required this.uuid,
    required this.resourceId,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      uuid: json['uuid'] as String,
      resourceId: json['resourceId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'resourceId': resourceId,
    };
  }

  @override
  String toString() =>
      'Bookmark(uuid: $uuid, resourceId: $resourceId)';
}

