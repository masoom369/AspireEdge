class Resource {
  final String title;
  final String description;
  final String category; // Blog, eBook, Video, Gallery
  final String tier; // Student, Graduate, Professional

  Resource({
    required this.title,
    required this.description,
    required this.category,
    required this.tier,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      tier: json['tier'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'tier': tier,
    };
  }

  @override
  String toString() => 'Resource(title: $title, description: $description, category: $category, tier: $tier)';
}
