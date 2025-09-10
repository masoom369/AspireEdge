class Media {
  final int id;
  final String url;
  final String type;
  final String title;

  Media({
    required this.id,
    required this.url,
    required this.type,
    required this.title,
  });

  Media.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        url = json["url"] as String,
        type = json["type"] as String,
        title = json["title"] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'type': type,
        'title': title,
      };
}