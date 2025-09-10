class Tier {
  final int id;
  final String slug;
  final String displayName;
  final String? description;

  Tier({
    required this.id,
    required this.slug,
    required this.displayName,
    this.description,
  });

  Tier.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        slug = json["slug"] as String,
        displayName = json["display_name"] as String,
        description = json["description"] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'display_name': displayName,
        'description': description,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'slug': slug,
        'display_name': displayName,
        'description': description,
      };
}
