class Career {
  final String id;
  final String title;
  final String description;

  Career({required this.id, required this.title, required this.description});

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  @override
  String toString() => 'Career(id: $id, title: $title, description: $description)';
}
