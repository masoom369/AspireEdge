class Testimonial {
  final String id;
  final String userName;
  final String message;
  final int rating;
  final String status;
  final String date;
  final String? image;
  final String? tier; // ✅ Add this

  Testimonial({
    required this.id,
    required this.userName,
    required this.message,
    required this.rating,
    required this.status,
    required this.date,
    this.image,
    this.tier, // ✅ Add this to constructor
  });

  /// Convert Testimonial object to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "message": message,
      "rating": rating,
      "status": status,
      "date": date,
      "image": image ?? "",
      "tier": tier ?? "", // ✅ Add tier to map
    };
  }

  /// Create Testimonial object from a Map
  factory Testimonial.fromMap(String id, Map<dynamic, dynamic> map) {
    return Testimonial(
      id: id,
      userName: map["userName"] ?? "",
      message: map["message"] ?? "",
      rating: map["rating"] ?? 0,
      status: map["status"] ?? "pending",
      date: map["date"] ?? "",
      image: map["image"],
      tier: map["tier"], // ✅ Fetch tier from Firebase
    );
  }
}
