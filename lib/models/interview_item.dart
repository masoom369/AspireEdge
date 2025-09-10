class InterviewItem {
  final int id;
  final String title;
  final String content;
  final int mediaId;
  final String category;

  InterviewItem({
    required this.id,
    required this.title,
    required this.content,
    required this.mediaId,
    required this.category,
  });

  InterviewItem.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        title = json["title"] as String,
        content = json["content"] as String,
        mediaId = json["media_id"] as int,
        category = json["category"] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'media_id': mediaId,
        'category': category,
      };
}