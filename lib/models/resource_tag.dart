class ResourceTag {
  final int resourceId;
  final int tagId;

  ResourceTag({
    required this.resourceId,
    required this.tagId,
  });

  ResourceTag.fromJson(Map<dynamic, dynamic> json)
      : resourceId = json["resource_id"] as int,
        tagId = json["tag_id"] as int;

  Map<String, dynamic> toJson() => {
        'resource_id': resourceId,
        'tag_id': tagId,
      };

  Map<String, dynamic> toMap() => {
        'resource_id': resourceId,
        'tag_id': tagId,
      };
}
