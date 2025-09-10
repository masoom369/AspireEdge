class CVTemplate {
  final int id;
  final String title;
  final String description;
  final int mediaId;
  final int uploadedBy;

  CVTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.mediaId,
    required this.uploadedBy,
  });

  CVTemplate.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        title = json["title"] as String,
        description = json["description"] as String,
        mediaId = json["media_id"] as int,
        uploadedBy = json["uploaded_by"] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'media_id': mediaId,
        'uploaded_by': uploadedBy,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'media_id': mediaId,
        'uploaded_by': uploadedBy,
      };
}
