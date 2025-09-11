class Media {
  final String id;
  final String url;
  final String type;

  Media({required this.id, required this.url, required this.type});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type,
    };
  }

  @override
  String toString() => 'Media(id: $id, url: $url, type: $type)';
}
