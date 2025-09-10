class QuizAnswer {
  final int id;
  final int attemptId;
  final int questionId;
  final int optionId;
  final String answerText;

  QuizAnswer({
    required this.id,
    required this.attemptId,
    required this.questionId,
    required this.optionId,
    required this.answerText,
  });

  QuizAnswer.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        attemptId = json["attempt_id"] as int,
        questionId = json["question_id"] as int,
        optionId = json["option_id"] as int,
        answerText = json["answer_text"] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'attempt_id': attemptId,
        'question_id': questionId,
        'option_id': optionId,
        'answer_text': answerText,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'attempt_id': attemptId,
        'question_id': questionId,
        'option_id': optionId,
        'answer_text': answerText,
      };
}
