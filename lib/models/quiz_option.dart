class QuizOption {
  final int id;
  final int questionId;
  final String label;
  final String optionText;

  QuizOption({
    required this.id,
    required this.questionId,
    required this.label,
    required this.optionText,
  });

  QuizOption.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        questionId = json["question_id"] as int,
        label = json["label"] as String,
        optionText = json["option_text"] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'question_id': questionId,
        'label': label,
        'option_text': optionText,
      };
}