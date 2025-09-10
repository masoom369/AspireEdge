class Testimonial {
  final int id;
  final int userId;
  final String displayName;
  final String imageUri;
  final int tierId;
  final String story;

  Testimonial({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.imageUri,
    required this.tierId,
    required this.story,
  });

  Testimonial.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        userId = json["user_id"] as int,
        displayName = json["display_name"] as String,
        imageUri = json["image_uri"] as String,
        tierId = json["tier_id"] as int,
        story = json["story"] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'display_name': displayName,
        'image_uri': imageUri,
        'tier_id': tierId,
        'story': story,
      };
}