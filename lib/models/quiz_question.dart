class QuizQuestion {
  final String id;
  final String question;

  QuizQuestion({required this.id, required this.question});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
    };
  }

  @override
  String toString() => 'QuizQuestion(id: $id, question: $question)';
}
