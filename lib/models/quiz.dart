class Quiz {
  final String id;
  final String title;

  Quiz({required this.id, required this.title});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  @override
  String toString() => 'Quiz(id: $id, title: $title)';
}
