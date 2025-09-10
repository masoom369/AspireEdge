class Tag {
  final int id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });

  Tag.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        name = json["name"] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}
