class WishlistItem {
  final String id;
  final String userId;
  final String resourceId;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.resourceId,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      resourceId: json['resourceId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'resourceId': resourceId,
    };
  }

  @override
  String toString() => 'WishlistItem(id: $id, userId: $userId, resourceId: $resourceId)';
}
