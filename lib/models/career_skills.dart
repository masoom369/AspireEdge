class CareerSkill {
  final int careerId;
  final int skillId;
  final int importance;

  CareerSkill({
    required this.careerId,
    required this.skillId,
    required this.importance,
  });

  CareerSkill.fromJson(Map<dynamic, dynamic> json)
      : careerId = json["career_id"] as int,
        skillId = json["skill_id"] as int,
        importance = json["importance"] as int;

  Map<String, dynamic> toJson() => {
        'career_id': careerId,
        'skill_id': skillId,
        'importance': importance,
      };
}