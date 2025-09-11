class InterviewItem {
  final String id;
  final String question;
  final String answer;

  InterviewItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory InterviewItem.fromJson(Map<String, dynamic> json) {
    return InterviewItem(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }

  @override
  String toString() => 'InterviewItem(id: $id, question: $question, answer: $answer)';
}
