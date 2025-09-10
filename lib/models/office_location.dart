class OfficeLocation {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;

  OfficeLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
  });

  OfficeLocation.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        name = json["name"] as String,
        address = json["address"] as String,
        latitude = json["latitude"] as double,
        longitude = json["longitude"] as double,
        phone = json["phone"] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
      };
}
