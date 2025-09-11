class QuizAttempt {
  final String id;
  final String userId;
  final String quizId;
  final int score;

  QuizAttempt({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.score,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'] as String,
      userId: json['userId'] as String,
      quizId: json['quizId'] as String,
      score: json['score'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'quizId': quizId,
      'score': score,
    };
  }

  @override
  String toString() =>
      'QuizAttempt(id: $id, userId: $userId, quizId: $quizId, score: $score)';
}
