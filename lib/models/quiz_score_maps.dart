class QuizScoreMap {
  final int id;
  final int optionId;
  final dynamic scoreMap;

  QuizScoreMap({
    required this.id,
    required this.optionId,
    required this.scoreMap,
  });

  QuizScoreMap.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        optionId = json["option_id"] as int,
        scoreMap = json["score_map"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'option_id': optionId,
        'score_map': scoreMap,
      };
}