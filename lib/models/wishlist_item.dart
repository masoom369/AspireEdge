class WishlistItem {
  final int id;
  final int userId;
  final String title;
  final String description;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
  });

  WishlistItem.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        userId = json["user_id"] as int,
        title = json["title"] as String,
        description = json["description"] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'description': description,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'description': description,
      };
}
