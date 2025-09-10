class EducationPath {
  final int id;
  final int careerId;
  final int stepOrder;
  final String title;
  final String? description;

  EducationPath({
    required this.id,
    required this.careerId,
    required this.stepOrder,
    required this.title,
    this.description,
  });

  EducationPath.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        careerId = json["career_id"] as int,
        stepOrder = json["step_order"] as int,
        title = json["title"] as String,
        description = json["description"] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'career_id': careerId,
        'step_order': stepOrder,
        'title': title,
        'description': description,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'career_id': careerId,
        'step_order': stepOrder,
        'title': title,
        'description': description,
      };
}
