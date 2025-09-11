class QuizOption {
  final String id;
  final String text;

  QuizOption({required this.id, required this.text});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  @override
  String toString() => 'QuizOption(id: $id, text: $text)';
}
