class CvTemplate {
  final String id;
  final String name;
  final String url;

  CvTemplate({required this.id, required this.name, required this.url});

  factory CvTemplate.fromJson(Map<String, dynamic> json) {
    return CvTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }

  @override
  String toString() => 'CvTemplate(id: $id, name: $name, url: $url)';
}
