class QuizQuestion {
  final int id;
  final int quizId;
  final String questionText;
  final String questionType;
  final int seq;

  QuizQuestion({
    required this.id,
    required this.quizId,
    required this.questionText,
    required this.questionType,
    required this.seq,
  });

  QuizQuestion.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        quizId = json["quiz_id"] as int,
        questionText = json["question_text"] as String,
        questionType = json["question_type"] as String,
        seq = json["seq"] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'quiz_id': quizId,
        'question_text': questionText,
        'question_type': questionType,
        'seq': seq,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'quiz_id': quizId,
        'question_text': questionText,
        'question_type': questionType,
        'seq': seq,
      };
}
