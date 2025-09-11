class QuizAnswer {
  final String id;
  final String answer;

  QuizAnswer({required this.id, required this.answer});

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      id: json['id'] as String,
      answer: json['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer': answer,
    };
  }

  @override
  String toString() => 'QuizAnswer(id: $id, answer: $answer)';
}
