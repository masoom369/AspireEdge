class QuizScoreMap {
  final String id;
  final int score;

  QuizScoreMap({required this.id, required this.score});

  factory QuizScoreMap.fromJson(Map<String, dynamic> json) {
    return QuizScoreMap(
      id: json['id'] as String,
      score: json['score'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score,
    };
  }

  @override
  String toString() => 'QuizScoreMap(id: $id, score: $score)';
}
