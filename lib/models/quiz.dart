class Quiz {
  final int id;
  final String title;
  final String description;
  final bool isActive;
  final int createdBy;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.createdBy,
  });

  Quiz.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        title = json["title"] as String,
        description = json["description"] as String,
        isActive = json["is_active"] as bool,
        createdBy = json["created_by"] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'is_active': isActive,
        'created_by': createdBy,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'is_active': isActive,
        'created_by': createdBy,
      };
}
