class Resource {
  final int id;
  final String title;
  final int typeId;
  final int authorId;
  final String content;
  final int? mediaId;
  final int publishedAt;
  final bool isPublished;

  Resource({
    required this.id,
    required this.title,
    required this.typeId,
    required this.authorId,
    required this.content,
    this.mediaId,
    required this.publishedAt,
    required this.isPublished,
  });

  Resource.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        title = json["title"] as String,
        typeId = json["type_id"] as int,
        authorId = json["author_id"] as int,
        content = json["content"] as String,
        mediaId = json["media_id"] as int?,
        publishedAt = json["published_at"] as int,
        isPublished = json["is_published"] as bool;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type_id': typeId,
        'author_id': authorId,
        'content': content,
        'media_id': mediaId,
        'published_at': publishedAt,
        'is_published': isPublished,
      };
}