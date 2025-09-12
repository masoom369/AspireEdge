class WishlistItem {
  final String userId;
  final String category;
  final String title;
  final String description;

  WishlistItem({
    required this.userId,
    required this.category,
    required this.title,
    required this.description,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      userId: json['userId'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'category': category,
      'title': title,
      'description': description,
    };
  }

  @override
  String toString() =>
      'WishlistItem(userId: $userId, category: $category, title: $title, description: $description)';
}