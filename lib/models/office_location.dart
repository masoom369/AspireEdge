class OfficeLocation {
  final String id;
  final String address;

  OfficeLocation({required this.id, required this.address});

  factory OfficeLocation.fromJson(Map<String, dynamic> json) {
    return OfficeLocation(
      id: json['id'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
    };
  }

  @override
  String toString() => 'OfficeLocation(id: $id, address: $address)';
}
