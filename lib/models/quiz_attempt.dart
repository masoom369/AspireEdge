class QuizAttempt {
  final int id;
  final int quizId;
  final int userId;
  final int startedAt;
  final int completedAt;
  final dynamic rawScore;
  final int? suggestedTierId;
  final int? suggestedCareerId;

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.startedAt,
    required this.completedAt,
    required this.rawScore,
    this.suggestedTierId,
    this.suggestedCareerId,
  });

  QuizAttempt.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        quizId = json["quiz_id"] as int,
        userId = json["user_id"] as int,
        startedAt = json["started_at"] as int,
        completedAt = json["completed_at"] as int,
        rawScore = json["raw_score"],
        suggestedTierId = json["suggested_tier_id"] as int?,
        suggestedCareerId = json["suggested_career_id"] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'quiz_id': quizId,
        'user_id': userId,
        'started_at': startedAt,
        'completed_at': completedAt,
        'raw_score': rawScore,
        'suggested_tier_id': suggestedTierId,
        'suggested_career_id': suggestedCareerId,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'quiz_id': quizId,
        'user_id': userId,
        'started_at': startedAt,
        'completed_at': completedAt,
        'raw_score': rawScore,
        'suggested_tier_id': suggestedTierId,
        'suggested_career_id': suggestedCareerId,
      };
}
