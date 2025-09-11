class Tier {
  final String id;
  final String name;

  Tier({required this.id, required this.name});

  factory Tier.fromJson(Map<String, dynamic> json) {
    return Tier(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'Tier(id: $id, name: $name)';
}
