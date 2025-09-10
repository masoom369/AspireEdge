class Skill {
  final int id;
  final String name;

  Skill({
    required this.id,
    required this.name,
  });

  Skill.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        name = json["name"] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}